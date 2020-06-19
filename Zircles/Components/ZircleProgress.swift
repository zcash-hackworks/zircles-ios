//
//  Wedge_Preview.swift
//  Zircles
//
//  Created by Francisco Gindre on 6/19/20.
//  Copyright © 2020 Electric Coin Company. All rights reserved.
//

import SwiftUI
struct ZircleProgress: View {
    var progress: Double = 0
    
    var body: some View {
        Wedge(startAngle: Angle(radians: 0),
              endAngle: Angle(radians: 2 * Double.pi * progress),
              clockwise: false)
            .stroke(style: .init(lineWidth: 40, lineCap: .round))
            .fill(LinearGradient.zButtonGradient)
            .rotationEffect(Angle(radians: -Double.pi / 2))
    }
}

struct Wedge_Previews: PreviewProvider {
    @State static var progress: Double = 0.75
    static var previews: some View {
        ZStack {
            Color.background
            VStack {
                ZircleProgress(progress: progress)
                    .glow(vibe: .heavy, soul: .split(left: Color.gradientPink, right: Color.gradientOrange))
                    .animation(.easeIn)
                Button(action: {
                    Self.progress = Double.random(in: 0 ... 1)
                    print(Self.progress)
                }) {
                    Text("Change progress")
                }
            }
            .padding(.all, 50)
        }
    }
}
