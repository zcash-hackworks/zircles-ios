//
//  CreateNewZircleDescription.swift
//  Zircles
//
//  Created by Francisco Gindre on 6/23/20.
//  Copyright © 2020 Electric Coin Company. All rights reserved.
//

import SwiftUI

struct CreateNewZircleDescription: View {
    
    enum ZircleFrequency: Int {
        case daily = 0
        case weekly
        case monthly
        
        var textDescription: String {
            switch self {
            case .daily:
                return "Daily"
            case .weekly:
                return "Weekly"
            case .monthly:
                return "Monthly"
            }
        }
        
    }
    enum ZircleEndDate {
        case onDate(date: Date)
        case atWill
        
        var optionIndex: Int {
            switch self {
            case .onDate(_):
               return 0
            case .atWill:
                return 1
            }
        }
        
        var textDescription: String {
            switch self {
            case .atWill:
                return "At Will"
            case .onDate:
                return "On Date"
            }
        }
    }
    @State var contributionFrequency: Int = ZircleFrequency.weekly.rawValue
    @State var endDate: Int = ZircleEndDate.atWill.optionIndex
    @State var zircleEndDate = Date()
    
    var body: some View {
        ZStack {
            Color.background
            VStack(spacing: 30) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Name of project")
                        .foregroundColor(.textLightGray)
                        .fontWeight(.heavy)
                        .font(.footnote)
                        .frame(alignment: .leading)
                    Card(isOn: .constant(true),cornerRadius: 5,padding: 8) {
                        
                        TextField("some title text", text: .constant("Hackathon Happy Hour"))
                            .foregroundColor(Color.textDarkGray)
                            .font(.system(size: 14, weight: .heavy, design: .default))
                        
                    }
                }.padding(.all, 0)
                
                VStack(alignment: .leading, spacing: 3) {
                    Text("Savings Goal")
                        .foregroundColor(.textLightGray)
                        .fontWeight(.heavy)
                        .font(.footnote)
                        .frame(alignment: .leading)
                    Card(isOn: .constant(true),cornerRadius: 5,padding: 8) {
                        
                        TextField("some title text", text: .constant("Hackathon Happy Hour"))
                            .foregroundColor(Color.textDarkGray)
                            .font(.system(size: 14, weight: .heavy, design: .default))
                        
                    }
                }.padding(.all, 0)
                VStack(alignment: .leading, spacing: 3) {
                    Text("Contribution Frequency")
                        .foregroundColor(.textLightGray)
                        .fontWeight(.heavy)
                        .font(.footnote)
                        .frame(alignment: .leading)
                    ZircleOptionSelector(
                        selection: $contributionFrequency,
                        ZircleFrequency.daily.textDescription,
                        ZircleFrequency.weekly.textDescription,
                        ZircleFrequency.monthly.textDescription
                    )
                }.padding(.all, 0)
                VStack(alignment: .leading, spacing: 3) {
                    Text("End Date")
                        .foregroundColor(.textLightGray)
                        .fontWeight(.heavy)
                        .font(.footnote)
                        .frame(alignment: .leading)
                    ZircleOptionSelector(
                        selection: $endDate,
                        ZircleEndDate.onDate(date: zircleEndDate).textDescription,
                        ZircleEndDate.atWill.textDescription
                    )
                }.padding(.all, 0)
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Text("Create New Zircle")
                        .font(.system(size: 20, weight: .bold, design: .default))
                        .shadow(color:Color(.sRGBLinear, red: 0.2, green: 0.2, blue: 0.2, opacity: 0.5), radius: 1, x: 0, y: 2)
                        .foregroundColor(Color.background)
                        .modifier(ZcashButtonBackground(buttonShape: .roundedCorners(fillStyle: .gradient(gradient: LinearGradient.zButtonGradient))))
                        
                        .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.2).opacity(0.5), radius: 25, x: 10, y: 10)
                        .frame(height: 50)
                })
            }.padding([.horizontal, .bottom],16)
            
        }.navigationBarTitle(Text("Now we need a goal and time period."))
    }
}

struct CreateNewZircleDescription_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewZircleDescription()
    }
}
