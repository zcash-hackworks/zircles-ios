//
//  ZirclesTests.swift
//  ZirclesTests
//
//  Created by Francisco Gindre on 6/16/20.
//  Copyright © 2020 Electric Coin Company. All rights reserved.
//

import XCTest
@testable import Zircles
@testable import ZcashLightClientKit
import Combine
class ZirclesTests: XCTestCase {
    
    var seedPhrase = "still champion voice habit trend flight survey between bitter process artefact blind carbon truly provide dizzy crush flush breeze blouse charge solid fish spread" //TODO: Parameterize this from environment?
    
    let testRecipientAddress = "zs17mg40levjezevuhdp5pqrd52zere7r7vrjgdwn5sj4xsqtm20euwahv9anxmwr3y3kmwuz8k55a" //TODO: Parameterize this from environment
    
    let sendAmount: Int64 = 1000
    var birthday: BlockHeight = 663150
    let defaultLatestHeight: BlockHeight = 663175
    var coordinator: TestCoordinator!
    var syncedExpectation = XCTestExpectation(description: "synced")
    var sentTransactionExpectation = XCTestExpectation(description: "sent")
    var expectedReorgHeight: BlockHeight = 665188
    var expectedRewindHeight: BlockHeight = 665188
    var reorgExpectation: XCTestExpectation = XCTestExpectation(description: "reorg")
    var cancellables = [AnyCancellable]()
    override func setUpWithError() throws {
        SeedManager.default.nukeWallet()
        coordinator = try TestCoordinator(
            seed: seedPhrase,
            walletBirthday: birthday,
            channelProvider: ChannelProvider()
        )
        try coordinator.reset(saplingActivation: 663150)
    }
    
    override func tearDownWithError() throws {
        NotificationCenter.default.removeObserver(self)
        try coordinator.stop()
        try? FileManager.default.removeItem(at: coordinator.databases.cacheDB)
        try? FileManager.default.removeItem(at: coordinator.databases.dataDB)
        try? FileManager.default.removeItem(at: coordinator.databases.pendingDB)
        SeedManager.default.nukeWallet()
    }
    
    func testNewCreateZircle() throws {
        try FakeChainBuilder.buildChain(darksideWallet: self.coordinator.service)
        let receivedTxHeight: BlockHeight = 663188
        
        /*
         2. applyStaged(received_Tx_height)
         */
        try coordinator.applyStaged(blockheight: receivedTxHeight)
        
        sleep(2)
        let preTxExpectation = XCTestExpectation(description: "pre receive")
        
        /*
         3. sync up to received_Tx_height
         */
        try coordinator.sync(completion: { (synchronizer) in
            preTxExpectation.fulfill()
        }, error: self.handleError)
        
        wait(for: [preTxExpectation], timeout: 5)
        
        let sendExpectation = XCTestExpectation(description: "sendToAddress")
        let endDate = Calendar.current.date(byAdding: .day, value: 7, to: Date())!
        
        var incomingZircle: ZircleEntity? = nil
        
        coordinator.combineSynchronizer
            .createNewZircle(name: "hackathon drinks",
                             goal: 3000000,
                             frequency: ZircleFrequency.daily,
                             endDate: ZircleEndDate.onDate(date: endDate),
                             spendingKey: coordinator.spendingKeys!.first!
            ).receive(on: DispatchQueue.main)
            .sink { (errorCompletion) in
                switch errorCompletion {
                case .failure(let error):
                    XCTFail("Test Failed - \(error)")
                default:
                    break
                }
                
            } receiveValue: { (zircle) in
                incomingZircle = zircle
                sendExpectation.fulfill()
            }
            .store(in: &cancellables)
        wait(for: [sendExpectation], timeout: 60)
        try coordinator.stageBlockCreate(height: receivedTxHeight + 1, count: 20)
        
        guard var receivedTx = try coordinator.getIncomingTransactions()?.first else {
            XCTFail("did not receive back previously sent transaction")
            return
        }
        
        
        let zircleTxHeight = 663190
      
        receivedTx.height = UInt64(zircleTxHeight)
        
        try coordinator.stageTransaction(receivedTx, at: zircleTxHeight)
        
        try coordinator.applyStaged(blockheight: zircleTxHeight)
        
        sleep(3)
        
        let postSendExpectation = XCTestExpectation(description: "post send expectation")
        try coordinator.sync(completion: { (_) in
            postSendExpectation.fulfill()
        }, error: self.handleError)
        
        wait(for: [postSendExpectation], timeout: 5)
        
        guard let sentNewZircleTx = coordinator.synchronizer.sentTransactions.filter({ (sentTx) -> Bool in
            sentTx.minedHeight == zircleTxHeight
        }).first else {
            XCTFail("Could not find Create New Zircle Transaction at height \(zircleTxHeight)")
            return
        }
        
        // let's try the memo thing out
        guard let memoData = sentNewZircleTx.memo else {
            XCTFail("retrieved transaction has no memo, when it should have")
            return
        }
        
        guard let memoString = memoData.asZcashTransactionMemo() else {
            XCTFail("retrieved transaction has a memo that can't be converted to string")
            return
        }
        var memoMessage: CreateZircleMessage! = nil
        do {
            memoMessage = try CreateZircleMessage(jsonString: memoString)
        } catch {
            XCTFail("failed to parse create new circle message")
            return
        }
        XCTAssertEqual(memoMessage.frequency.rawValue, incomingZircle?.frequency)
        XCTAssertEqual(memoMessage.name, incomingZircle?.name)
//        XCTAssertEqual(memoMessage.goal, incomingZircle?.goal)
        
    }
    
    func handleError(_ error: Error?) {
        _ = try? coordinator.stop()
        guard let testError = error else {
            XCTFail("failed with nil error")
            return
        }
        XCTFail("Failed with error: \(testError)")
    }
}
