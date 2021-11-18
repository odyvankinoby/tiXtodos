//
//  Settings.swift
//  tiX
//
//  Created by Nicolas Ott on 09.10.21.
//

import SwiftUI
import MessageUI
import WebKit


struct Settings: View {
    
    // Observable Objects
    @Environment(\.managedObjectContext) var viewContext
    @ObservedObject var settings: UserSettings
    @StateObject var storeManager: StoreManager
    
    @Binding var tabSelected: Int
    
    @State var showPremium = false
    
    var body: some View {
        
        VStack {
            
            
            HStack {
                
                Button(action: {
                    withAnimation {
                        self.tabSelected = 2
                    }
                }) {
                    Image(systemName: "list.bullet.circle").foregroundColor(Color(settings.globalForeground)).font(.title).padding(.top)
                }
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        self.tabSelected = 1
                    }
                }) {
                    Image(systemName: "house.circle").foregroundColor(Color(settings.globalForeground)).font(.title).padding(.top)
                }
            }
            
            HStack {
                Text(loc_settings)
                    .font(.title).bold()
                    .foregroundColor(Color(settings.globalForeground))
                    .frame(alignment: .leading)
                    .padding(.top, 5)
                Spacer()
                
            }
            
            ScrollView {
                
                SettingsApp(settings: settings).environment(\.managedObjectContext, viewContext)
                
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "crown")
                            .font(.title3)
                            .foregroundColor(.yellow)
                        Text(loc_premium).frame(alignment: .leading).foregroundColor(Color(settings.globalText))
                        Spacer()
                        if settings.purchased {
                            Text(loc_purchased).frame(alignment: .leading).foregroundColor(.tixDark)
                        }
                    }.onTapGesture {
                        showPremium.toggle()
                    }
                    
                }
                .padding(10)
                .background(Color.white)
                .cornerRadius(10)
                .frame(maxWidth: .infinity)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(settings.globalBackground == "White" ? Color.tix : Color(settings.globalForeground), lineWidth: 1).padding(1)
                )
                
                SettingsColors(settings: settings, storeManager: storeManager)
                                
                SettingsIcons(settings: settings, storeManager: storeManager).environment(\.managedObjectContext, viewContext)
                
                SettingsSupport(settings: settings)
                
                SettingsInfo(settings: settings)
                
                VStack(alignment: .leading) {
                    
                    
                    HStack {
                        Text(loc_more_apps).frame(alignment: .leading).foregroundColor(Color(settings.globalText))
                        Spacer()
                    }.frame(alignment: .leading).onTapGesture(perform: {
                        if let url = URL(string: "https://apps.apple.com/developer/nicolas-ott/id1527796947") {
                            UIApplication.shared.open(url)
                        }
                    })
                    
                }
                .padding(10)
                .background(Color.white)
                .cornerRadius(10)
                .frame(maxWidth: .infinity)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(settings.globalBackground == "White" ? Color.tix : Color(settings.globalForeground), lineWidth: 1).padding(1)
                )
                
                // DEVELOPER
                if settings.developerMode {
                    VStack(alignment: .leading) {
                        Toggle(isOn: $settings.purchased) {
                            Text("Premium")
                                .foregroundColor(Color(settings.globalText)).frame(alignment: .trailing)
                        }.padding(.leading).padding(.trailing)
                    }
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(settings.globalBackground == "White" ? Color.tix : Color(settings.globalForeground), lineWidth: 1).padding(1)
                    )
                }
                // DEVELOPER
                
                VStack(alignment: .leading) {
                    HStack {
                        Text(loc_madewithlove).font(.footnote).foregroundColor(Color(settings.globalForeground))
                    }
                }
                .padding(10).padding(.bottom, 100)
                .frame(maxWidth: .infinity)
            }
            
            
        }
        .sheet(isPresented: self.$showPremium) {
            InAppPurchase(settings: settings, storeManager: storeManager)
        }
        .accentColor(Color(settings.globalText))
        .padding(.leading).padding(.trailing)
        .background(Color(settings.globalBackground))
    }
}


