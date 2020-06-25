//
//  FirstScreen.swift
//  Zircles
//
//  Created by Francisco Gindre on 6/24/20.
//  Copyright © 2020 Electric Coin Company. All rights reserved.
//

import SwiftUI

struct FirstScreen<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    var body: some View {
        NavigationView {
            content
        }
    }
}

struct FirstScreen_Previews: PreviewProvider {
    static var previews: some View {
        FirstScreen() {
            ZStack {
                Color.background
                Text("hello")
            }.navigationBarTitle("Welcome")
        }
    }
}
