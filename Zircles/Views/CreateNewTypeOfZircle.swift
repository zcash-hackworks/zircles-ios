//
//  CreateNewTypeOfZircle.swift
//  Zircles
//
//  Created by Francisco Gindre on 6/22/20.
//  Copyright © 2020 Electric Coin Company. All rights reserved.
//

import SwiftUI

struct CreateNewTypeOfZircle: View {
    var body: some View {
        ZStack {
            Color.background.edgesIgnoringSafeArea(.all)
            VStack(spacing: 32 ) {
                Spacer()
                Text("Savings Circle")
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .shadow(color:Color(red: 0.2, green: 0.2, blue: 0.2).opacity(0.2), radius: 1, x: 0, y: 2)
                    .foregroundColor(Color.buttonBlue)
                    .modifier(ZcashButtonBackground(buttonShape: .roundedCorners(fillStyle: .solid(color: Color.background))))
                    
                    .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.2).opacity(0.3), radius: 15, x: 10, y: 15)
                    .shadow(color: Color.white.opacity(0.5), radius: 25, x:-10, y: -10)
                    .frame(height: 50)
                
                Text("Savings Goal")
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .shadow(color:Color(red: 0.2, green: 0.2, blue: 0.2).opacity(0.2), radius: 1, x: 0, y: 2)
                    .foregroundColor(Color.background)
                    .modifier(ZcashButtonBackground(buttonShape: .roundedCorners(fillStyle: .solid(color: Color.buttonBlue))))
                    
                    .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.2).opacity(0.5), radius: 25, x: 10, y: 10)
                    .frame(height: 50)
                
                NavigationLink(
                    destination: CreateNewZircleDescription())
                    {
                Text("Group Budget Goal")
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .shadow(color:Color(.sRGBLinear, red: 0.2, green: 0.2, blue: 0.2, opacity: 0.5), radius: 1, x: 0, y: 2)
                    .foregroundColor(Color.background)
                    .modifier(ZcashButtonBackground(buttonShape: .roundedCorners(fillStyle: .gradient(gradient: LinearGradient.zButtonGradient))))
                    
                    .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.2).opacity(0.5), radius: 25, x: 10, y: 10)
                    .frame(height: 50)
                }
                Card(isOn: .constant(false),cornerRadius: 10, padding: 16) {
                    ZircleProgress(progress: 0.7, stroke: .init(lineWidth: 5, lineCap: .round))
                        .glow(vibe: .heavy, soul: .split(left: Color.gradientPink, right: Color.gradientOrange))
                        .frame(width: 30, height: 30)
                }
                Text("Import Existing Zircle")
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .shadow(color:Color(red: 0.2, green: 0.2, blue: 0.2).opacity(0.2), radius: 1, x: 0, y: 2)
                    .foregroundColor(Color.textDarkGray)
                    .modifier(ZcashButtonBackground(buttonShape: .roundedCorners(fillStyle: .solid(color: Color.buttonGray))))
                    
                    .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.2).opacity(0.5), radius: 25, x: 10, y: 10)
                    .frame(height: 50)
                
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 30)
        }.navigationBarTitle(Text("What Type of Savings Project?"))
    }
}

struct CreateNewTypeOfZircle_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewTypeOfZircle()
    }
}
