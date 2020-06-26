//
//  ZirclesEnvironment.swift
//  Zircles
//
//  Created by Francisco Gindre on 6/24/20.
//  Copyright © 2020 Electric Coin Company. All rights reserved.
//

import Foundation
import SwiftUI
import ZcashLightClientKit
import Combine
enum WalletState {
    case initalized
    case uninitialized
    case syncing
    case synced
}

protocol AppEnvironment {
    func createNewWallet() throws
    func nuke(abortApplication: Bool)
    func getMainAddress() -> String
    func getUsername() -> String
    func getMainSeedPhrase() -> String
    func getLatestHeight() -> Int64
}

final class ZirclesEnvironment: ObservableObject {
    enum WalletError: Error {
        case createFailed
        case initializationFailed(message: String)
        case genericError(message: String)
        case connectionFailed(message: String)
        case maxRetriesReached(attempts: Int)
    }
    static let genericErrorMessage = "An error ocurred, please check your device logs"
    static var shared: ZirclesEnvironment = try! ZirclesEnvironment() // app can't live without this existing.
    
    @Published var state: WalletState
    var errorPublisher = PassthroughSubject<Error,Never>()
    let endpoint = LightWalletEndpoint(address: ZcashSDK.isMainnet ? "lightwalletd.z.cash" : "lightwalletd.testnet.z.cash", port: 9067, secure: true)
    var dataDbURL: URL
    var cacheDbURL: URL
    var pendingDbURL: URL
    var outputParamsURL: URL
    var spendParamsURL: URL
    var initializer: Initializer {
        synchronizer.initializer
    }
    var synchronizer: CombineSynchronizer
    var cancellables = [AnyCancellable]()
    
    static func getInitialState() -> WalletState {
        guard let keys = SeedManager.default.getKeys(), keys.count > 0 else {
            return .uninitialized
        }
        return .initalized
    }
    
    static func isInitialized() -> Bool {
        switch getInitialState() {
        case .uninitialized:
            return false
        default:
            return true
        }
    }
    
    private init() throws {
        self.dataDbURL = try URL.dataDbURL()
        self.cacheDbURL = try URL.cacheDbURL()
        self.pendingDbURL = try URL.pendingDbURL()
        self.outputParamsURL = try URL.outputParamsURL()
        self.spendParamsURL = try  URL.spendParamsURL()
        
        self.state = Self.getInitialState()
        
        let initializer = Initializer(
            cacheDbURL: self.cacheDbURL,
            dataDbURL: self.dataDbURL,
            pendingDbURL: self.pendingDbURL,
            endpoint: endpoint,
            spendParamsURL: self.spendParamsURL,
            outputParamsURL: self.outputParamsURL,
            loggerProxy: logger)
        self.synchronizer = try CombineSynchronizer(initializer: initializer)
        cancellables.append(
            self.synchronizer.status.map({
                status -> WalletState in
                switch status {
                case .synced:
                    return WalletState.synced
                case .syncing:
                    return WalletState.syncing
                default:
                    return Self.getInitialState()
                    
                }
            }).sink(receiveValue: { status  in
                self.state = status
            })
        )
        
    }
    
    func createNewWallet() throws {
        
        guard let randomPhrase = MnemonicSeedProvider.default.randomMnemonic(),
            let randomSeed = MnemonicSeedProvider.default.toSeed(mnemonic: randomPhrase) else {
                throw WalletError.createFailed
        }
        let birthday = WalletBirthday.birthday(with: BlockHeight.max)
        try SeedManager.default.importSeed(randomSeed)
        try SeedManager.default.importBirthday(birthday.height)
        try SeedManager.default.importPhrase(bip39: randomPhrase)
        try self.initialize()
    }
    
    func initialize() throws {
        
        if let keys = try self.initializer.initialize(seedProvider: SeedManager.default, walletBirthdayHeight: try SeedManager.default.exportBirthday()) {
            
            SeedManager.default.saveKeys(keys)
        }
        
        
        self.synchronizer.start()
    }
    
    static var appBuild: String? {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    }
    
    static var appVersion: String? {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    func isValidAddress(_ address: String) -> Bool {
        self.initializer.isValidShieldedAddress(address) || self.initializer.isValidTransparentAddress(address)
    }
    func sufficientFundsToSend(amount: Double) -> Bool {
        return sufficientFunds(availableBalance: self.initializer.getVerifiedBalance(), zatoshiToSend: amount.toZatoshi())
    }
    private func sufficientFunds(availableBalance: Int64, zatoshiToSend: Int64) -> Bool {
        availableBalance - zatoshiToSend  - Int64(ZcashSDK.MINERS_FEE_ZATOSHI) >= 0
    }
    static var minerFee: Double {
        Int64(ZcashSDK.MINERS_FEE_ZATOSHI).asHumanReadableZecBalance()
    }
    
    /**
     only for internal use
     */
    func nuke(abortApplication: Bool = false) {
        self.synchronizer.stop()
        
        SeedManager.default.nukeWallet()
        
        do {
            try FileManager.default.removeItem(at: self.dataDbURL)
        } catch {
            logger.error("could not nuke wallet: \(error)")
        }
        do {
            try FileManager.default.removeItem(at: self.cacheDbURL)
        } catch {
            logger.error("could not nuke wallet: \(error)")
        }
        do {
            try FileManager.default.removeItem(at: self.pendingDbURL)
        } catch {
            logger.error("could not nuke wallet: \(error)")
        }
        
        if abortApplication {
            abort()
        }
    }
    
    
    deinit {
        cancellables.forEach {
            c in
            c.cancel()
        }
    }
    
}
extension Error {
    static func mapError(error: Error) -> ZirclesEnvironment.WalletError {
        
        if let rustError = error as? RustWeldingError {
            switch rustError {
            case .genericError(let message):
                return ZirclesEnvironment.WalletError.genericError(message: message)
            case .dataDbInitFailed(let message):
                return ZirclesEnvironment.WalletError.genericError(message: message)
            case .dataDbNotEmpty:
                return ZirclesEnvironment.WalletError.genericError(message: "attempt to initialize a db that was not empty")
            case .saplingSpendParametersNotFound:
                return ZirclesEnvironment.WalletError.createFailed
            case .malformedStringInput:
                return ZirclesEnvironment.WalletError.genericError(message: "Malformed address or key detected")
            default:
                return ZirclesEnvironment.WalletError.genericError(message: "\(rustError)")
            }
        } else if let synchronizerError = error as? SynchronizerError {
            switch synchronizerError {
            case .generalError(let message):
                return ZirclesEnvironment.WalletError.genericError(message: message)
            case .initFailed(let message):
                return ZirclesEnvironment.WalletError.initializationFailed(message: "Synchronizer failed to initialize: \(message)")
            case .syncFailed:
                return ZirclesEnvironment.WalletError.genericError(message: "Synchronizing failed")
            case .connectionFailed(let message):
                return ZirclesEnvironment.WalletError.connectionFailed(message: message)
            case .maxRetryAttemptsReached(attempts: let attempts):
                return ZirclesEnvironment.WalletError.maxRetriesReached(attempts: attempts)
            case .connectionError(_, let message):
                return ZirclesEnvironment.WalletError.connectionFailed(message: message)
            }
        }
        
        return ZirclesEnvironment.WalletError.genericError(message: ZirclesEnvironment.genericErrorMessage)
    }
}

extension ZirclesEnvironment: AppEnvironment {
    func getMainAddress() -> String {
        self.initializer.getAddress(index: 0) ?? "No address!!"
    }
    
    func getUsername() -> String {
        ZircleDataStorage.default.username
    }
    
    func getMainSeedPhrase() -> String {
        guard let phrase = try? SeedManager.default.exportPhrase() else {
            return "no phrase"
        }
        return phrase
    }
    
    func getLatestHeight() -> Int64 {
        Int64(synchronizer.syncBlockHeight.value)
    }
    
    
}


