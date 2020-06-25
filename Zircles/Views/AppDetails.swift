//
//  AppDetails.swift
//  Zircles
//
//  Created by Francisco Gindre on 6/24/20.
//  Copyright © 2020 Electric Coin Company. All rights reserved.
//

import SwiftUI

struct AppDetails: View {
    @State var showNukeAlert = false
    
    var body: some View {
        ZStack {
            Color.background.edgesIgnoringSafeArea(.all)
            
            VStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Username")
                        .foregroundColor(.textLightGray)
                        .fontWeight(.heavy)
                        .font(.footnote)
                        .frame(alignment: .leading)
                    Card(isOn: .constant(true),cornerRadius: 5,padding: 8) {
                        
                        Text(ZircleDataStorage.default.username)
                            .foregroundColor(Color.textDarkGray)
                            .font(.system(size: 14, weight: .heavy, design: .default))
                        
                    }
                }.padding(.all, 0)
                VStack(alignment: .leading, spacing: 3) {
                    Text("App Version")
                        .foregroundColor(.textLightGray)
                        .fontWeight(.heavy)
                        .font(.footnote)
                        .frame(alignment: .leading)
                    Card(isOn: .constant(true),cornerRadius: 5,padding: 8) {
                        
                        Text("Zircles v\(ZirclesEnvironment.appVersion ?? "Unknown") - Build:  \(ZirclesEnvironment.appBuild ?? "Unknown")")
                            .foregroundColor(Color.textDarkGray)
                            .font(.system(size: 14, weight: .heavy, design: .default))
                        
                    }
                }.padding(.all, 0)
                
                Button(action: {
                    self.showNukeAlert = true
                }) {
                    Text("NUKE WALLET")
                        .foregroundColor(.red)
                        .zcashButtonBackground(shape: .roundedCorners(fillStyle: .outline(color: .red, lineWidth: 2)))
                        .frame(height: 48)
                }.alert(isPresented: $showNukeAlert) {
                    Alert(title: Text("Delete Wallet?"),
                          message: Text("You are about to")+Text(" nuke your wallet. ").foregroundColor(.red) + Text("Are you sure you want to proceed?"),
                          primaryButton: .default(
                            Text("I'm not sure")
                            ,action: { self.showNukeAlert = false}
                          ),
                          secondaryButton: .destructive(
                            Text("NUKE WALLET!"),
                            action: {
                                ZirclesEnvironment.shared.nuke(abortApplication: true)
                            }
                          )
                    )
                }
            }
        }.navigationBarTitle(Text("Backstage"))
        .navigationBarItems(trailing: Button(action:{
            
        }){
            Text("close")
        })
    }
}

struct AppDetails_Previews: PreviewProvider {
    static var previews: some View {
        AppDetails()
    }
}
