//
//  AllZirclesView.swift
//  Zircles
//
//  Created by Francisco Gindre on 6/25/20.
//  Copyright © 2020 Electric Coin Company. All rights reserved.
//

import SwiftUI
import UIKit
struct ZircleSummary {
    var progress: Double
    var name: String
    var paymentDue: Bool
}
struct AllZirclesView: View {
    @State var detailsActive = false
    var zircles: [ZircleSummary]
    var paymentsDueLegend: String {
        let paymentsDue = zircles.filter({ $0.paymentDue}).count
        return "You Have \(zircles.count) \( zircles.count > 1 ? "Zircles" : "Zircle"). \(paymentsDue > 0 ? String(paymentsDue) : "No") \(paymentsDue == 1 ? "payment" : "payments") due"
    }
    var body: some View {
        ZStack {
            Color.background.edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    
                    FancyLogo(progress: .constant(0.75))
                            .scaleEffect(0.3)
                            .disabled(true)
                        .background(EmptyView())
                        
                    Text(paymentsDueLegend)
                        .lineLimit(2)
                        .foregroundColor(.black)
                        .font(.title)
                    
                }
                .frame(height: 50)
                
                
                List {
                    ForEach(0 ..< zircles.count) { index in
                        VStack {
                        ZircleListCard(summary: zircles[index])
                        }
                        .padding(.vertical, 30)
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                        
                    }
                }
                
            }
            
        }
        .onAppear() {
            
            UITableView.appearance().separatorStyle = .none
            UITableView.appearance().backgroundColor = UIColor.clear
            
        }
        .onDisappear() {
            UITableView.appearance().separatorStyle = .singleLine
            UITableView.appearance().backgroundColor = UIColor.white
            
        }
        .navigationBarTitle("", displayMode: .inline)
        .sheet(isPresented: $detailsActive) {
            AppDetails(isActive: $detailsActive,appEnvironment: MockAppEnvironment())
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(trailing: Button(action: {
            self.detailsActive = true
        }){
            Image(systemName: "z.circle")
                .frame(width: 30, height: 30, alignment: .center)
                
        }
        .contentShape(Circle())
        )
        .sheet(isPresented: $detailsActive) {
            AppDetails(isActive: $detailsActive,appEnvironment: MockAppEnvironment())
        }
       
    }
}

extension ZircleListCard {
    init(summary: ZircleSummary) {
        self.name = summary.name
        self.progress = summary.progress
    }
}
struct AllZirclesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ZStack{
                AllZirclesView(
                    zircles: [
                        ZircleSummary(progress: 0.5, name: "Hackathon Drinks", paymentDue: false),
                        ZircleSummary(progress: 0.02, name: "Long-term Circle", paymentDue: true)
                        
                    ]
                )
            }
        }
    }
}
