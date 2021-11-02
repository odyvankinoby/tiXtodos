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
    
    @State private var username = ""
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: { self.presentationMode.wrappedValue.dismiss() } )
                {
                    Image(systemName: "xmark").padding().foregroundColor(.white)
                }
            }
            ScrollView  {
                HStack(alignment: .center) {
                    Image("AppIcons")
                        .resizable()
                        .cornerRadius(18)
                        .frame(width: 96, height: 96, alignment: .center)
                    VStack(alignment: .leading) {
                        Text(loc_welcome).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).foregroundColor(.white).allowsTightening(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                    Text(loc_tix).font(.title3).foregroundColor(.white).allowsTightening(true)
                    }.padding(.leading, 10)
                   
                }.padding()
                VStack(alignment: .center) {
                    Text(loc_how).font(.body).foregroundColor(.white).bold().allowsTightening(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/).padding()
                    TextField("", text: $username)
                        .frame(alignment: .center)
                        //.frame(maxWidth: .infinity)
                        .foregroundColor(Color.tix)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }.padding()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Button(action: {
                    withAnimation {
                        settings.userName = self.username
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("Start tiX").foregroundColor(.white)
                }.customButton()
                 .frame(maxWidth: .infinity).disabled(username.isEmpty)
            }
        }
        .onAppear(perform: onAppear)
        .background(Color.tix)
        .edgesIgnoringSafeArea(.all)
    }
    
    func onAppear() {
        isFocused = true
    }
}
