//
//  InvitePeople.swift
//  Zircles
//
//  Created by Francisco Gindre on 7/3/20.
//  Copyright © 2020 Electric Coin Company. All rights reserved.
//

import SwiftUI

struct InvitePeople: View {
    let liberatedZircle: String
    @State var isSharing = false
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Image("Invite").edgesIgnoringSafeArea(.all)
                    .frame(alignment: .top)
                Spacer()
            }
            VStack(spacing:20) {
                Spacer()
                HStack() {
                    Text("""
                        Invite
                        Some Peeps
                        """)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                .padding(.horizontal, 30)
                ZStack {
                    Color.background
                    VStack(spacing: 20) {
                        Text("This is your Sharing Link")
                            .font(.title)
                            
                        Text(liberatedZircle)
                            .font(.body)
                            .lineLimit(3)
                            .truncationMode(.middle)
                            .foregroundColor(.textLightGray)
                        Button(action:{}){
                            Text("Copy To clipboard")
                                .font(.system(size: 20, weight: .bold, design: .default))
                                .shadow(color:Color(red: 0.2, green: 0.2, blue: 0.2).opacity(0.2), radius: 1, x: 0, y: 2)
                                .foregroundColor(Color.textDarkGray)
                                .modifier(ZcashButtonBackground(buttonShape: .roundedCorners(fillStyle: .solid(color: Color.buttonGray))))
                                
                                .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.2).opacity(0.5), radius: 25, x: 10, y: 10)
                                .frame(height: 50)
                        }
                        Button(action: {
                            self.isSharing = true
                        }, label: {
                            Text("Invite People")
                                .font(.system(size: 20, weight: .bold, design: .default))
                                .shadow(color:Color(red: 0.2, green: 0.2, blue: 0.2).opacity(0.2), radius: 1, x: 0, y: 2)
                                .foregroundColor(Color.background)
                                .modifier(ZcashButtonBackground(buttonShape: .roundedCorners(fillStyle: .solid(color: Color.buttonBlue))))
                                
                                .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.2).opacity(0.5), radius: 25, x: 10, y: 10)
                                .frame(height: 50)
                        })
                    }
                    .padding(.all, 30)
                }.cornerRadius(25, corners: [.topLeft,.topRight])
                .frame(height: 300,
                       alignment: .bottom)
            }.background(Color.clear)
        }
        .navigationBarTitle("", displayMode: .inline)
        .sheet(isPresented: $isSharing) {
            ShareSheet(activityItems: [liberatedZircle])
        }
    }
}


struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct InvitePeople_Previews: PreviewProvider {
    static var previews: some View {
        InvitePeople(liberatedZircle: LiberatedInviteHandler.inviteWith(name: "Hackathon Drinks", viewingkey: "zxviews1qvhluf0pqqqqpq8ywsuq89wulufzghltkt76vz33rrhpaekeakr68at2lglxwfuxkth58vw8cp9s8z0qguqzxc0wfaz6f4mp7vfs47hex6n38tczds7uakalf3a25qwth56v8tz95p4qfyjquk7thwzr3uq6hwgwu4emxm3wrf3yspgatcvup83pl96jrvaymznxa5vdlh6dfgfuzja3egv96hg5eyelrlgkf29su9hucds8zjt2lnsqlcaajq7klkjxc40v80d6sfqkvwjet", height: 663190).absoluteString)
    }
}
