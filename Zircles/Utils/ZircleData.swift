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
    static let autoIdKey = "autoid"
    static var `default`: ZircleDataStorage = ZircleDataStorage()
    
    private init() {}
    
    func saveUsername(_ name: String) {
        UserDefaults.standard.setValue(name, forKey: Self.usernameKey)
    }
    var username: String {
        UserDefaults.standard.string(forKey: Self.usernameKey) ?? ""
    }
    
    var autoId: String {
        if let autoid = UserDefaults.standard.string(forKey: Self.autoIdKey) {
            return autoid
        }
        
        let newId = "zirclesUser\(Int.random(in: 0 ... Int.max))"
        UserDefaults.standard.setValue(newId, forKey: Self.autoIdKey)
        return newId
    }
}
