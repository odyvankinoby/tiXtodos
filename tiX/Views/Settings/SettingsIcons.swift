//
//  SettingsIcons.swift
//  tiX
//
//  Created by Nicolas Ott on 13.11.21.
//

import SwiftUI
import UIKit
import MessageUI
import WebKit
import CoreData

struct SettingsIcons: View {
    
    // Observable Objects
    @Environment(\.managedObjectContext) var viewContext
    @ObservedObject var settings: UserSettings
    @StateObject var storeManager: StoreManager
    @State var showPremium = false
    
    @State var selection = UIApplication.shared.alternateIconName ?? "AppIcon"
    
    @State var icons1 = ["AppIcons",
                         "IconTixDark",
                         "IconGray",
                         "IconBrown",
                         "IconWhite"]
    
    @State var icons2 = ["IconRed",
                         "IconPink",
                         "IconOrange",
                         "IconYellow",
                         "IconGreen"]
    
    @State var icons3 = ["IconMint",
                         "IconTeal",
                         "IconCyan",
                         "IconBlue",
                         "IconIndigo"]
    
    var body: some View {
        
        VStack(alignment: .leading)
        {
            HStack {
                Text(loc_app_icon)
                    .frame(alignment: .leading)
                    .foregroundColor(Color(settings.globalForeground))
                    .padding(10)
                Spacer()
            }
            .background(RoundedCorners(color: Color(settings.globalBackground), tl: 10, tr: 10, bl: 0, br: 0))
            HStack {
                Spacer()
                ForEach(icons1, id: \.self) { ico in
                    Button(action: {
                        withAnimation {
                            setIcon(ico: ico)
                        }
                    }) {
                        Image(ico)
                            .resizable()
                            .cornerRadius(8)
                            .frame(width: 40, height: 40)
                            .frame(alignment: .leading)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(ico == "IconWhite" && ico == settings.icon ? Color.tix : ico == settings.icon ? Color.yellow : Color.white, lineWidth: 1)
                            )
                    }
                    Spacer()
                }
            }.padding(.leading).padding(.trailing)
            Divider()
            HStack {
                Spacer()
                ForEach(icons2, id: \.self) { ico in
                    Button(action: {
                        withAnimation {
                            setIcon(ico: ico)
                        }
                    }) {
                        Image(ico)
                            .resizable()
                            .cornerRadius(8)
                            .frame(width: 40, height: 40)
                            .frame(alignment: .leading)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(ico == "IconYellow" && ico == settings.icon ? Color.tix : ico == settings.icon ? Color.yellow : Color.white, lineWidth: 1)
                            )
                        
                    }
                    Spacer()
                }
            }.padding(.leading).padding(.trailing)
            HStack {
                Spacer()
                ForEach(icons3, id: \.self) { ico in
                    Button(action: {
                        withAnimation {
                            setIcon(ico: ico)
                        }
                    }) {
                        Image(ico)
                            .resizable()
                            .cornerRadius(8)
                            .frame(width: 40, height: 40)
                            .frame(alignment: .leading)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(ico == settings.icon ? Color.yellow : Color.white, lineWidth: 1)
                            )
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
    
    func setIcon(ico: String) {
        if settings.purchased {
            UIApplication.shared.setAlternateIconName(ico == "AppIcons" ? nil : "App\(ico)")
            settings.icon = ico
        } else {
            showPremium.toggle()
        }
    }
}
