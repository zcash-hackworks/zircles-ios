//
//  InviteHandler.swift
//  Zircles
//
//  Created by Francisco Gindre on 7/3/20.
//  Copyright © 2020 Electric Coin Company. All rights reserved.
//

import Foundation
/**
 Liberated Invite
 3 parameters
 https://invite.zircles.co?vk=xxxxxxxxxx&height=xxxxxxxxx&name=xxxxxxx
 */

struct LiberatedInvite {
    let name: String
    let viewingKey: String
    let height: Int
}

class LiberatedInviteHandler {
    
    enum InviteComponents: String {
        case scheme = "https"
        case host = "invite.zircles.co"
        case viewingKey = "vk"
        case height
        case name
    }
    
    static func inviteWith(name: String,
                    viewingkey: String,
                    height: Int) -> URL {
        
        let nameItem = URLQueryItem(name: InviteComponents.name.rawValue, value: name)
        let viewingkeyItem = URLQueryItem(name: InviteComponents.viewingKey.rawValue, value: viewingkey)
        let heightItem = URLQueryItem(name: InviteComponents.height.rawValue, value: String(height))
        
        var components = URLComponents()
        components.scheme = InviteComponents.scheme.rawValue
        components.host = InviteComponents.host.rawValue
        components.queryItems = [ nameItem, viewingkeyItem, heightItem]
        
        return components.url!
    }
    
    static func parseInvite(_ url: URL) -> LiberatedInvite? {
        guard url.host == InviteComponents.host.rawValue else {
            return nil
        }
        
        guard let parsedScheme = url.scheme,
              parsedScheme == InviteComponents.scheme.rawValue else {
            return nil
        }
        
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return nil
        }
        
        guard let vk = components.queryItems?.first(where: { $0.name == InviteComponents.viewingKey.rawValue})?.value else {
            return nil
        }
        
        guard let name = components.queryItems?.first(where: {$0.name == InviteComponents.name.rawValue})?.value else {
            return nil
        }
        
        guard let heightParam = components.queryItems?.first(where: { $0.name == InviteComponents.height.rawValue })?.value,
              let height = Int(heightParam) else {
            return nil
        }
        
        return LiberatedInvite(name: name,
                               viewingKey: vk,
                               height: height)
    }
}
