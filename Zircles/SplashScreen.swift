//
//  ContentView.swift
//  Zircles
//
//  Created by Francisco Gindre on 6/16/20.
//  Copyright © 2020 Electric Coin Company. All rights reserved.
//

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        
        NavigationView {
            ZStack {
                Color.background
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    FancyLogo()
                        .frame(width: 200, height: 200)
                    Spacer()
                    Button(action: {}) {
                        Text("Create New")
                            .font(.system(size: 20, weight: .bold, design: .default))
                            .shadow(color:Color(red: 0.2, green: 0.2, blue: 0.2).opacity(0.2), radius: 1, x: 0, y: 2)
                        .foregroundColor(Color.background)
                            .modifier(ZcashButtonBackground(buttonShape: .roundedCorners(fillStyle: .solid(color: Color.buttonBlue))))
                        
                            .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.2).opacity(0.5), radius: 25, x: 10, y: 10)
                            .frame(height: 50)
                    }
                }.padding(30)
                
                
            }.navigationBarTitle(Text("Welcome to Zircles"))
        }
        
    }
}

struct FancyLogo: View {
    var body: some View {

        ZStack {
            Pie(isOn: .constant(false),padding: 16) {
                    Pie(isOn: .constant(true), padding: 40) {
                        Pie(isOn: .constant(false)) {
                            
                            Text("")
                            .padding(40)
                            
                        }
                        
                    }
                    .overlay(
                        ZircleProgress(progress: 0.75, stroke:  .init(lineWidth: 40, lineCap: .round))
                        .padding(23)
                        
                    )
                    
            }
            Text("$")
            .foregroundColor(.buttonGray)
            .font(
                .custom("Zboto", size: 200)
            ).padding()
                .frame(alignment: .center)
            .contentShape(Circle())
            .offset(x: 0, y: 50)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
