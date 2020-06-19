//
//  ZircleTextFiel.swift
//  Zircles
//
//  Created by Francisco Gindre on 6/19/20.
//  Copyright © 2020 Electric Coin Company. All rights reserved.
//

import SwiftUI

struct ZircleTextField_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.background
            VStack {
                
                
                Card(isOn: .constant(true),cornerRadius: 5,padding: 8) {
                    
                    TextField("some title text", text: .constant("Hackathon Happy Hour"))
                        .foregroundColor(Color.textDarkGray)
                        .font(.system(size: 14, weight: .heavy, design: .default))
                    
                }
                
            }.padding(.all, 40)
            
        }
    }
}
