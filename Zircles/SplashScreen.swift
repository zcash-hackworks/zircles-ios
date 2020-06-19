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
                FancyLogo()
                    .frame(width: 100, height: 200)
            }.navigationBarTitle(Text("Welcome to Zircles"))
        }
        
    }
}

struct FancyLogo: View {
    var body: some View {
        GeometryReader { geometry in
            
            ZStack {
                
                ZcashSymbol().path(in: geometry.frame(in: .local))
                    .fill(Color.gray)
                
                ZircleProgress(progress: 0.75)
                    .glow(vibe: .heavy, soul: .split(left: Color.gradientPink, right: Color.gradientOrange))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
