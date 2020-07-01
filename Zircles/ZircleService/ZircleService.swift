//
//  ZircleService.swift
//  Zircles
//
//  Created by Francisco Gindre on 6/29/20.
//  Copyright © 2020 Electric Coin Company. All rights reserved.
//

import Foundation
import Combine

enum ZircleServiceError: Error {
    case generalError(message: String)
}
protocol ZircleService {
    func createNewZircle(name: String, goal zatoshi: Int64, frequency: ZircleFrequency, endDate: ZircleEndDate, spendingKey: String) throws -> Future<ZircleEntity, Error>
    func closeZircle(name: String) throws
    func contribute(zatoshi: Int64, zircle: ZircleEntity) throws
    func allOpenZircles() throws -> [ZircleEntity]?
    func allContributions(from zircle: ZircleEntity) -> Future<[ZircleOverallContribution],Error>
    func openInvite(_ url: URL) -> Future<Int,Error>
    
}
protocol ZircleOverallContribution {
    var from: String { get set }
    var zAddr: String { get set }
    var zatoshi: Int64 { get set }
}
protocol ZircleContribution {
    var from: String { get set }
    var zatoshi: Int64 { get set }
    var date: Date { get set }
}

protocol ZircleEntity {
    var name: String { get set}
    var goal: Int64 { get set }
    var frequency: Int {get set }
    var endDate: TimeInterval { get set }
    var accountIndex: Int {get set}
    var address: String {get set}
}

enum ZircleFrequency: Int {
    case daily = 0
    case weekly
    case monthly
    
}
enum ZircleEndDate {
    case onDate(date: Date)
    case atWill
    
}


struct ConcreteZircle: ZircleEntity {
    var name: String
    
    var goal: Int64
    
    var frequency: Int
    
    var endDate: TimeInterval
    
    var accountIndex: Int
    
    var address: String
    
    
}
import MnemonicSwift

extension CombineSynchronizer: ZircleService {
    func closeZircle(name: String) throws {
        
    }
    
    func contribute(zatoshi: Int64, zircle: ZircleEntity) throws {
        
    }
    
    func allOpenZircles() throws -> [ZircleEntity]? {
        nil
    }
    
    func allContributions(from zircle: ZircleEntity) -> Future<[ZircleOverallContribution], Error> {
        Future<[ZircleOverallContribution], Error>() { promise in
            promise(.success([]))
        }
    }
    
    func openInvite(_ url: URL) -> Future<Int, Error> {
        Future<Int, Error>() { promise in
            promise(.success(-1))
        }
    }
    
    func createNewZircle(name: String, goal zatoshi: Int64, frequency: ZircleFrequency, endDate: ZircleEndDate, spendingKey: String) -> Future<ZircleEntity, Error> {
        
        Future<ZircleEntity, Error>() { promise in
            var storage = [AnyCancellable]()
            
            DispatchQueue.global().async { [weak self] in
                guard let self = self else { return }
                
                // Get latest height from chain and generate a mnemonic seed for this zircle
                Publishers.Zip(self.latestHeight(),
                               Mnemonic.generatePublisher(strength: 256)
                ).sink(receiveCompletion: { error in
                    switch error {
                    case .failure(let e):
                        promise(.failure(e))
                    default:
                        break
                    }
                }, receiveValue: { (height, seedPhrase) in
                    guard let seedBytes = Mnemonic.deterministicSeedBytes(from: seedPhrase) else {
                        promise(.failure(ZircleServiceError.generalError(message: "mnemonic bytes failed")))
                        return
                    }
                    do {
                        // start derivation
                        let derivationHelper = self.initializer.keyDerivationHelper()
                        
                        // derive extended spending keys, and extended Viewing Keys
                        guard let extendedSpendingKeys = try derivationHelper.deriveExtendedSpendingKeys(seed: seedBytes, accounts: 1),
                              let extendedSpendingKey = extendedSpendingKeys.first,
                              let extendedViewingKey = try derivationHelper.deriveExtendedFullViewingKey(extendedSpendingKey) else {
                            promise(.failure(ZircleServiceError.generalError(message: "Key derivation error")))
                            return
                        }
                        
                     
                     
                        // import extended viewing key
                        let accountIndex = try self.initializer.importExtendedFullViewingKey(extendedViewingKey)
                        
                        // get zAddr for this zircle
                        
                        guard let zAddr = self.initializer.getAddress(index: Int(accountIndex)) else {
                            promise(.failure(ZircleServiceError.generalError(message: "coudn't get zAddr for account index: \(accountIndex)")))
                            return
                        }
                        
                        
                        // set end date per input
                        var end: TimeInterval = -1
                        
                        switch endDate {
                        case .onDate(let date):
                            end = date.timeIntervalSince1970
                        default:
                            break
                        }
                        
                        // create zircle struct
                        let zircle = ConcreteZircle(name: name,
                                       goal: zatoshi,
                                       frequency: frequency.rawValue,
                                       endDate: end,
                                       accountIndex: Int(accountIndex),
                                       address: zAddr)
                        
                      
                        // get supporting wallet spending keys to create zircle
                      
                        
                        guard let freq = CreateZircleMessage.ContributionFrequency(rawValue: zircle.frequency) else {
                            promise(.failure(ZircleServiceError.generalError(message: "could not create frequency with value \(zircle.frequency)")))
                            return
                        }
                        
                        // create protobut message for the memo
                        let createMessage = CreateZircleMessage.with { (createMsg) in
                            createMsg.name = zircle.name
                            createMsg.goal = UInt64(zircle.goal)
                            createMsg.frequency = freq
                            createMsg.end = UInt64(zircle.endDate)
                        }
                        
                        // not sure if this is ok, but I don't have a data interface
                        let memo = try createMessage.jsonString()
                        
                        // double check that the resulting data won't be truncated. this should be caught earlier on  UI
                        guard memo.utf8.count <= 512 else {
                            promise(.failure(ZircleServiceError.generalError(message: "Zircle Message \"\(memo)\" is longer than 512 bytes - total: \(memo.utf8.count)")))
                            return
                        }
                        // save before sending
                       try SeedManager.default.saveKeys(name,
                                                        phrase: seedPhrase,
                                                        height: height,
                                                        spendingKey: extendedSpendingKey)
                        // fund zircle
                        self.send(with: spendingKey,
                                  zatoshi: 1000,
                                  to: zAddr,
                                  memo: memo,
                                  from: 0)
                            .sink { errorSubscriber in
                            switch errorSubscriber {
                            case .failure(let underlyingError):
                                promise(.failure(underlyingError))
                            default:
                                break
                            }
                        } receiveValue: { (p) in
                            promise(.success(zircle))
                        }.store(in: &storage)

                    } catch {
                        promise(.failure(error))
                    }
                }).store(in: &storage)
            }
            
        }
    }
    
    
    func allContributions(from zircle: ZircleEntity) throws -> [ZircleOverallContribution] {
        []
    }
    
    func openInvite(_ url: URL) throws {
        
    } 
}

extension Mnemonic {
    static func generatePublisher(strength: Int) -> Future<String, Error> {
        
        Future<String,Error>() { promise in
            
            DispatchQueue.global().async {
                guard let mnemonic = Mnemonic.generateMnemonic(strength: strength) else {
                    promise(.failure(ZircleServiceError.generalError(message: "Error generating mnemonic")))
                    return
                }
                
                promise(.success(mnemonic))
            }
        }
    }
}
