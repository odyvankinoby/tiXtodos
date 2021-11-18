//
//  Update.swift
//  tiX
//
//  Created by Nicolas Ott on 01.11.21.
//

import SwiftUI

struct UpdateView: View {
    
    @ObservedObject var settings: UserSettings
    @Environment(\.presentationMode) var presentationMode
   
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    withAnimation {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text(loc_discard)
                        .foregroundColor(Color(settings.globalForeground))
                }
                .buttonStyle(PlainButtonStyle())
            }.padding(.top).padding(.bottom)
            
            ScrollView {
                VStack(alignment: .leading) {
                    HStack(alignment: .center) {
                        Image("\(settings.icon)")
                            .resizable()
                            .cornerRadius(18)
                            .frame(width: 96, height: 96)
                            .padding(10)
                            .frame(alignment: .leading)
                        VStack(alignment: .leading) {
                            Text(loc_welcome)
                                .font(.title)
                                .foregroundColor(Color(settings.globalForeground))
                                .allowsTightening(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                
                            Text(loc_tix)
                                .font(.title2)
                                .foregroundColor(Color(settings.globalForeground))
                                .allowsTightening(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                
                            Text("Version \(settings.appVersion)")
                                .font(.title3)
                                .foregroundColor(Color(settings.globalForeground))
                        }
                    }
                    Text(loc_whatsnew)
                        .font(.headline)
                        .foregroundColor(Color(settings.globalForeground))
                    Text(loc_rn)
                        .font(.subheadline)
                        .foregroundColor(Color(settings.globalForeground))
                }
            }
           
        }
        .padding(.leading)
        .padding(.trailing)
        .accentColor(Color(settings.globalForeground))
        .background(Color(settings.globalBackground))
    }
}
