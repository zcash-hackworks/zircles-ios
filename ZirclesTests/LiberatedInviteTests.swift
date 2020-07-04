//
//  LiberatedInviteTests.swift
//  ZirclesTests
//
//  Created by Francisco Gindre on 7/3/20.
//  Copyright © 2020 Electric Coin Company. All rights reserved.
//

import XCTest
@testable import Zircles
class LiberatedInviteTests: XCTestCase {

    let extendedViewingKey: String =     "zxviews1qvhluf0pqqqqpq8ywsuq89wulufzghltkt76vz33rrhpaekeakr68at2lglxwfuxkth58vw8cp9s8z0qguqzxc0wfaz6f4mp7vfs47hex6n38tczds7uakalf3a25qwth56v8tz95p4qfyjquk7thwzr3uq6hwgwu4emxm3wrf3yspgatcvup83pl96jrvaymznxa5vdlh6dfgfuzja3egv96hg5eyelrlgkf29su9hucds8zjt2lnsqlcaajq7klkjxc40v80d6sfqkvwjet"
    
    let zircleName = "Hackathon Drinks"
    let height: Int = 663190
    
    func expectedUrlString() -> String {
            LiberatedInviteHandler.InviteComponents.scheme.rawValue +
            "://" +
            LiberatedInviteHandler.InviteComponents.host.rawValue + "?name=\(zircleName.replacingOccurrences(of: " ", with: "%20"))&vk=\(extendedViewingKey)&height=\(height)"
    }
    
    func testHappyPath() throws {
        guard let parsedInvite = LiberatedInviteHandler.parseInvite(URL(string: expectedUrlString())!) else {
            XCTFail("parsed invite nil")
            return
        }
        XCTAssertEqual(parsedInvite.name, zircleName)
        XCTAssertEqual(parsedInvite.height, height)
        XCTAssertEqual(parsedInvite.viewingKey, extendedViewingKey)
    }
    
    func testLiberatedPaymentGeneration() {
        let invite = LiberatedInviteHandler.inviteWith(name: zircleName, viewingkey: extendedViewingKey, height: height)
        
        XCTAssertEqual(invite, URL(string: expectedUrlString())!)
    }
}
