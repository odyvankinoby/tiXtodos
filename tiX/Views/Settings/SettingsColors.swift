//
//  SettingsColors.swift
//  tiX
//
//  Created by Nicolas Ott on 13.11.21.
//

import SwiftUI

struct SettingsColors: View {
    
    @ObservedObject var settings: UserSettings
    @StateObject var storeManager: StoreManager
    @State var showPremium = false
    
    @State var colorz1 = ["tix",
                          "tixDark",
                          "Gray",
                          "Brown",
                          "White"]
    
    @State var colorz2 = ["Red",
                          "Pink",
                          "Orange",
                          "Yellow",
                          "Green"]
    
    @State var colorz3 = ["Mint",
                          "Teal",
                          "Cyan",
                          "Blue",
                          "Indigo"]
    
    var body: some View {
        
        VStack(alignment: .leading)
        {
            HStack {
                Text(loc_app_bg)
                    .frame(alignment: .leading)
                    .foregroundColor(Color(settings.globalForeground))
                    .padding(10)
                Spacer()
            }
            .background(RoundedCorners(color: Color(settings.globalBackground), tl: 10, tr: 10, bl: 0, br: 0))
            
            HStack {
                Spacer()
                ForEach(colorz1, id: \.self) { col in
                    Button(action: {
                        withAnimation {
                            setColors(col: col)
                        }
                    }) {
                        Image(systemName: col == settings.globalBackground ? col == "White" ? "dot.square" : "dot.square.fill" : col == "White" ? "square" : "square.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(col == "White" ? Color.tixDark : Color(col))
                    }
                    Spacer()
                }
                
            }.padding(.leading).padding(.trailing)
            Divider()
            
            HStack {
                Spacer()
                ForEach(colorz2, id: \.self) { col in
                    Button(action: {
                        withAnimation {
                            setColors(col: col)
                        }
                    }) {
                        Image(systemName: col == settings.globalBackground ? col == "White" ? "dot.square" : "dot.square.fill" : col == "White" ? "square" : "square.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(col == "White" ? Color.tixDark : Color(col))
                    }
                    Spacer()
                }
                
            }.padding(.leading).padding(.trailing)
            HStack {
                Spacer()
                ForEach(colorz3, id: \.self) { col in
                    Button(action: {
                        withAnimation {
                            setColors(col: col)
                        }
                    }) {
                        Image(systemName: col == settings.globalBackground ? col == "White" ? "dot.square" : "dot.square.fill" : col == "White" ? "square" : "square.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(col == "White" ? Color.tixDark : Color(col))
                    }
                    Spacer()
                }
                
            }.padding(.leading).padding(.trailing).padding(.bottom)
        }
        .background(Color.white)
        .cornerRadius(10)
        .frame(maxWidth: .infinity)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(settings.globalBackground == "White" ? Color.tix : Color(settings.globalForeground), lineWidth: 1).padding(1)
        )
        .sheet(isPresented: self.$showPremium) {
            InAppPurchase(settings: settings, storeManager: storeManager)
        }
        
    }
    
    func setColors(col: String) {
        if settings.purchased {
            settings.globalBackground = col
            settings.globalForeground = col == "White" ? "tix" : "White"
            settings.globalText = col == "White" ? "tix" : col
        } else {
            showPremium.toggle()
        }
    }
    
}
