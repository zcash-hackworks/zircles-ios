//
//  zECC+SwiftUI.swift
//  wallet
//
//  Created by Francisco Gindre on 2/12/20.
//  Copyright © 2020 Francisco Gindre. All rights reserved.
//

import Foundation
import SwiftUI

extension ZcashButton {
    static func nukeButton() -> ZcashButton {
        ZcashButton(color: Color.red, fill: Color.clear, text: "NUKE WALLET")
    }
}
