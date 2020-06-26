//
//  ZircleListCard.swift
//  Zircles
//
//  Created by Francisco Gindre on 6/25/20.
//  Copyright © 2020 Electric Coin Company. All rights reserved.
//

import SwiftUI

struct ZircleListCard: View {
    var name: String
    var progress: Double
    
    @State var isPressed = false
    var body: some View {
        Toggle(isOn: $isPressed) {
            HStack(spacing: 16) {
                Toggle(isOn: $isPressed) {
                    if progress < 0.5 {
                        Image("downchart")
                            .renderingMode(.original)
                    } else {
                        Image("upchart")
                            .renderingMode(.original)
                    }
                }.toggleStyle(SimpleToggleStyle(shape: RoundedRectangle(cornerRadius: 10, style: .continuous), padding: 16))
                VStack {
                    HStack {
                        Text(name)
                            .foregroundColor(.zGray)
                            .shadow(radius: 1)
                        Text("\(Int(progress))%")
                            .foregroundColor(.zGray)
                            .shadow(radius: 1)
                    }
                    NeumorphicProgressBar(progress: .constant(CGFloat(progress)), fillStyle: progress < 0.5 ? Color.red : Color.green )
                        .frame(minWidth: 100, idealWidth: 100, maxWidth: .infinity, minHeight: 5, idealHeight: 5, maxHeight: 5, alignment: .center)
                }
            }
        }
        .toggleStyle(SimpleToggleStyle(shape: RoundedRectangle(cornerRadius: 10, style: .continuous),padding:16))
    }
}

struct ZircleListCard_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.background
            Group {
            ZircleListCard(name: "Hackathon Drinks", progress: 0.5)
            ZircleListCard(name: "Long-term Circle", progress: 0.02)
            }
        }
    }
}
