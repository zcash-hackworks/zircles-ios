//
//  Glow.swift
//  Zircles
//
//  Created by Francisco Gindre on 6/17/20.
//  Copyright © 2020 Electric Coin Company. All rights reserved.
//

import Foundation
import SwiftUI

struct GlowButtons_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {

            Color.background
            VStack(spacing: 60) {
                   Text("Mild Glow")
                       .font(.system(size: 20, weight: .bold, design: .default))
                       .shadow(color:Color(red: 0.2, green: 0.2, blue: 0.2).opacity(0.2), radius: 1, x: 0, y: 2)
                   .foregroundColor(Color.background)
                       .modifier(ZcashButtonBackground(buttonShape: .roundedCorners(fillStyle: .solid(color: Color.buttonBlue))))
                   
                      
                       .glow(vibe: .mild, soul: .solid(color: Color.buttonBlue))
                       .frame(height: 50)
                Text("Cool Glow")
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .shadow(color:Color(red: 0.2, green: 0.2, blue: 0.2).opacity(0.2), radius: 1, x: 0, y: 2)
                .foregroundColor(Color.background)
                    .modifier(ZcashButtonBackground(buttonShape: .roundedCorners(fillStyle: .solid(color: Color.buttonBlue))))
                

                    .glow(vibe: .cool, soul: .solid(color: Color.buttonBlue))
                    .frame(height: 50)
                
                Text("Heavy Glow")
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .shadow(color:Color(red: 0.2, green: 0.2, blue: 0.2).opacity(0.2), radius: 1, x: 0, y: 2)
                .foregroundColor(Color.background)
                    .modifier(ZcashButtonBackground(buttonShape: .roundedCorners(fillStyle: .solid(color: Color.buttonBlue))))
                
                  
                    .glow(vibe: .heavy, soul: .solid(color: Color.buttonBlue))
                    .frame(height: 50)
                Spacer()
                Text("Mild Glow")
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .shadow(color:Color(.sRGBLinear, red: 0.2, green: 0.2, blue: 0.2, opacity: 0.5), radius: 1, x: 0, y: 2)
                .foregroundColor(Color.background)
                .modifier(ZcashButtonBackground(buttonShape: .roundedCorners(fillStyle: .gradient(gradient: LinearGradient.zButtonGradient))))
                
                    .glow(vibe: .mild,
                          soul: .split(left: .gradientPink,
                                       right: .gradientOrange))
                    .frame(height: 50)
                
                Text("Month")
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .shadow(color:Color(.sRGBLinear, red: 0.2, green: 0.2, blue: 0.2, opacity: 0.5), radius: 1, x: 0, y: 2)
                .foregroundColor(Color.background)
                .modifier(ZcashButtonBackground(buttonShape: .roundedCorners(fillStyle: .gradient(gradient: LinearGradient.zButtonGradient))))
                    .glow(vibe: .heavy, soul: .split(left: .gradientPink, right: .gradientOrange))
                    .frame(width: 160, height: 80)
              
            }.padding(40)
        }
    }
}
