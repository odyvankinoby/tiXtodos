//
//  SettingsSupport.swift
//  tiX
//
//  Created by Nicolas Ott on 13.11.21.
//

import SwiftUI
import MessageUI
import WebKit

struct SettingsSupport: View {
    
    @ObservedObject var settings: UserSettings
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var noMail = false
    
    var body: some View {
        
        VStack(alignment: .leading)
        {
            
            HStack {
                Text(loc_app_support)
                    .frame(alignment: .leading)
                    .foregroundColor(Color(settings.globalForeground))
                    .padding(10)
                Spacer()
            }
            .background(RoundedCorners(color: Color(settings.globalBackground), tl: 10, tr: 10, bl: 0, br: 0))
            
            HStack {
                Text(loc_help).frame(alignment: .leading).foregroundColor(Color(settings.globalText))
                Spacer()
            }
            .frame(alignment: .leading)
            .onTapGesture(perform: {
                if let url = URL(string: "https://www.nicolasott.de/en/tix/support/index.html") {
                    UIApplication.shared.open(url)
                }
            })
            .padding(.leading).padding(.trailing)
            
            Divider()
            
            HStack {
                NavigationLink(destination: MailView(result: self.$result).accentColor(Color(settings.globalText))
                                .edgesIgnoringSafeArea(.bottom)) {
                    HStack {
                        Text(loc_feedback).frame(alignment: .leading).foregroundColor(noMail ? .gray : Color(settings.globalText))
                        Spacer()
                    }
                }.disabled(!MFMailComposeViewController.canSendMail())
            }.padding(.leading).padding(.trailing)
            
            Divider()
            
            HStack {
                Text(loc_contact).frame(alignment: .leading).foregroundColor(Color(settings.globalText))
                Spacer()
            }
            .frame(alignment: .leading)
            .onTapGesture(perform: {
                if let url = URL(string: "https://www.nicolasott.de/en/contact/") {
                    UIApplication.shared.open(url)
                }
            })
            .padding(.leading).padding(.trailing)
            
            Divider()
            HStack {
                Text("Twitter").frame(alignment: .leading).foregroundColor(Color(settings.globalText))
                Spacer()
            }
            .frame(alignment: .leading)
            .onTapGesture(perform: {
                if let url = URL(string: "https://twitter.com/trax_tracker") {
                    UIApplication.shared.open(url)
                }
            })
            .padding(.leading).padding(.trailing).padding(.bottom)
            
        }
        .background(Color.white)
        .cornerRadius(10)
        .frame(maxWidth: .infinity)
        .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(settings.globalBackground == "White" ? Color.tix : Color(settings.globalForeground), lineWidth: 1).padding(1)
            )
        .onAppear(perform: onAppear)
    }
    
    func onAppear() {
        if !MFMailComposeViewController.canSendMail() {
            self.noMail = true
        }
    }
}
