//
//  Card.swift
//  Zircles
//
//  Created by Francisco Gindre on 6/18/20.
//  Copyright © 2020 Electric Coin Company. All rights reserved.
//

import SwiftUI

struct Card<Content: View>: View {
    @Binding var isToggled: Bool
    var cornerRadius: CGFloat
    var padding: CGFloat
    let content: Content
    init(isOn: Binding<Bool>, cornerRadius: CGFloat = 25, padding: CGFloat = 30, @ViewBuilder content: () -> Content) {
        self.padding = padding
        self.cornerRadius = cornerRadius
        self._isToggled = isOn
        self.content = content()
    }
    var body: some View {
        Toggle(isOn: $isToggled) {
            content
        }
        .toggleStyle(SimpleToggleStyle(shape: RoundedRectangle(cornerRadius: cornerRadius), padding: padding))
    }
}

struct Card_Previews: PreviewProvider {
    @State static var isToggled: Bool = false
    static var previews: some View {
        ZStack {
            Color.background
            Card(isOn: $isToggled) {
                Image(systemName: "heart.fill")
                .foregroundColor(.gray)
                .frame(width: 200, height: 200)
            }
        }
    }
}
