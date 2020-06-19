//
//  ProgressBar.swift
//  Zircles
//
//  Created by Francisco Gindre on 6/19/20.
//  Copyright © 2020 Electric Coin Company. All rights reserved.
//

import SwiftUI

struct ProgressBar: View {
    @Binding var progress: CGFloat
    var body: some View {
        
        GeometryReader { geometry in
            
            Path { path in
                
                path.move(to: CGPoint(x: 0,
                                      y: geometry.size.height/2
                                    )
                )
                
                path.addLine(to: CGPoint(
                                    x: geometry.size.width * max(0,min(self.progress, 1)),
                                    y: geometry.size.height/2
                                )
                )
                
            }
            .stroke(style: .init(lineWidth: geometry.size.height, lineCap: .round))
            .fill(LinearGradient.zButtonGradient)
            
        }
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        
        ZStack {
            Color.background
            VStack {
                Card(isOn: .constant(true),
                     cornerRadius: 15,
                     padding: 5
                     ) {
                        ProgressBar(progress: .constant(0.6))
                            .animation(.easeInOut)
                        .frame(height: 30)
                        .padding(.horizontal)
                }       
            }.padding()
        }
    }
}
