//
//  Onboarding.swift
//  tiX
//
//  Created by Nicolas Ott on 01.11.21.
//

import SwiftUI

struct SetupView: View {
    
    @ObservedObject var settings: UserSettings
    @Environment(\.presentationMode) var presentationMode
    @FocusState private var isFocused: Bool
    
    @State private var name = true
   
    @State var colorz1 = ["tix", "tixDark", "Brown", "Orange", "Red", "Magenta"]
    @State var colorz2 = ["Cyan", "Green", "Blue", "Purple", "Yellow", "White"]
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: { self.presentationMode.wrappedValue.dismiss() } )
                {
                    Image(systemName: "xmark").padding().foregroundColor(Color(settings.globalForeground))
                }
            }
            ScrollView  {
                HStack(alignment: .center) {
                    Image("AppIcons")
                        .resizable()
                        .cornerRadius(18)
                        .frame(width: 96, height: 96, alignment: .center)
                    VStack(alignment: .leading) {
                        Text(loc_welcome).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).foregroundColor(Color(settings.globalForeground)).allowsTightening(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                    Text(loc_tix).font(.title3).foregroundColor(Color(settings.globalForeground)).allowsTightening(true)
                    }.padding(.leading, 10)
                   
                }.padding()
                
                if name {
                    Text(loc_how).font(.body).foregroundColor(Color(settings.globalForeground)).bold().allowsTightening(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/).padding()
                    VStack(alignment: .center) {
                        TextField("", text: $settings.userName)
                            .frame(alignment: .center)
                            .foregroundColor(Color.tix)
                            .padding()
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity)
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Button(action: {
                        withAnimation {
                            name = false
                        }
                    }) {
                        Text(loc_ok)
                    }.foregroundColor(.tix)
                        .padding(10)
                        .background(Color.white)
                        .cornerRadius(8)
                     .disabled(settings.userName.isEmpty)
                } else {
                    Text(loc_theme).font(.body).foregroundColor(Color(settings.globalForeground)).bold().allowsTightening(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/).padding()
                    VStack(alignment: .leading) {
                        HStack {
                            Spacer()
                            ForEach(colorz1, id: \.self) { col in
                                Button(action: {
                                    withAnimation {
                                        settings.globalBackground = col
                                        settings.globalForeground = "White"
                                    }
                                }) {
                                    Image(systemName: col == settings.globalBackground ? "dot.square.fill" : "square.fill")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(Color(col))
                                }
                                Spacer()
                            }
                            
                        }
                        HStack {
                            Spacer()
                            ForEach(colorz2, id: \.self) { col in
                                Button(action: {
                                    withAnimation {
                                        settings.globalBackground = col
                                        settings.globalForeground = "tix"
                                    }
                                }) {
                                    Image(systemName: col == settings.globalBackground ? col == "White" ? "dot.square" : "dot.square.fill" : col == "White" ? "square" : "square.fill")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(col == "White" ? Color.tixDark : Color(col))
                                }
                                Spacer()
                            }
                            
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity)
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Button(action: {
                        withAnimation {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Text(loc_go)
                    }.foregroundColor(.tix)
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(8)
                     
                }
                
            }.padding(.leading).padding(.trailing)
        }
        .onAppear(perform: onAppear)
        .onDisappear(perform: onDisappear)
        .background(Color(settings.globalBackground))
        .edgesIgnoringSafeArea(.all)
    }
    
    func onAppear() {
        isFocused = true
    }
    func onDisappear() {
        settings.launchedBefore = true
    }
}
