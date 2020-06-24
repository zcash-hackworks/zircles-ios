//
//  CreateNewZircleNameView.swift
//  Zircles
//
//  Created by Francisco Gindre on 6/22/20.
//  Copyright © 2020 Electric Coin Company. All rights reserved.
//

import SwiftUI

struct CreateNewZircleNameView: View {
    var body: some View {
        ZStack {
            Color.background
            VStack(spacing: 50) {

                Card(isOn: .constant(true),cornerRadius: 5,padding: 8) {
                    
                    TextField("some title text", text: .constant("Hackathon Happy Hour"))
                        .foregroundColor(Color.textDarkGray)
                        .font(.system(size: 14, weight: .heavy, design: .default))
                    
                }
                
                Text("Continue")
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .shadow(color:Color(red: 0.2, green: 0.2, blue: 0.2).opacity(0.2), radius: 1, x: 0, y: 2)
                    .foregroundColor(Color.buttonBlue)
                    .modifier(ZcashButtonBackground(buttonShape: .roundedCorners(fillStyle: .solid(color: Color.background))))
                    
                    .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.2).opacity(0.3), radius: 15, x: 10, y: 15)
                    .shadow(color: Color.white.opacity(0.5), radius: 25, x:-10, y: -10)
                    .frame(height: 50)
                Spacer()
            }
            .padding(.top, 100)
            .padding(.horizontal, 30)
            
            
        }
        .navigationBarTitle("Groups Savings Project Name?")
    }
}

struct CreateNewZircleNameView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewZircleNameView()
    }
}
