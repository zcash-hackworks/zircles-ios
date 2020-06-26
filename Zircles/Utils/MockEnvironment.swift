//
//  MockEnvironment.swift
//  Zircles
//
//  Created by Francisco Gindre on 6/25/20.
//  Copyright © 2020 Electric Coin Company. All rights reserved.
//

import Foundation

class MockAppEnvironment: AppEnvironment, ObservableObject {
    func createNewWallet() throws {}
    func nuke(abortApplication: Bool) {}
    func getMainAddress() -> String {
        "zsFakefejaefnq2rrneferjgbrauiebnfiosjebfeyetqoq3"
    }
    func getUsername() -> String {
        "pacu"
    }
    func getMainSeedPhrase() -> String {
        "kitchen renew wide common vague fold vacuum tilt amazing pear square gossip jewel month tree shock scan alpha just spot fluid toilet view dinner"
    }
    
    func getLatestHeight() -> Int64 {
        999999
    }
}
