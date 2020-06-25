//
//  ZircleData.swift
//  Zircles
//
//  Created by Francisco Gindre on 6/24/20.
//  Copyright © 2020 Electric Coin Company. All rights reserved.
//

import Foundation

class ZircleDataStorage {
    static let usernameKey = "zircleusername"
    static var `default`: ZircleDataStorage = ZircleDataStorage()
    
    private init() {}
    
    func saveUsername(_ name: String) {
        UserDefaults.standard.setValue(name, forKey: Self.usernameKey)
    }
    var username: String {
        UserDefaults.standard.string(forKey: Self.usernameKey) ?? ""
    }
    
}
