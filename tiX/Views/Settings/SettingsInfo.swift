//
//  SettingsInfo.swift
//  tiX
//
//  Created by Nicolas Ott on 13.11.21.
//

import SwiftUI
import MessageUI
import WebKit

struct SettingsInfo: View {
    
    @ObservedObject var settings: UserSettings
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var noMail = false
    
    @State var showAbout = false
    @State var showGDPR = false
    
    var body: some View {
        VStack(alignment: .leading)
        {
            HStack {
                Text(loc_app_info)
                    .frame(alignment: .leading)
                    .foregroundColor(Color(settings.globalForeground))
                    .padding(10)
                Spacer()
            }
            .background(RoundedCorners(color: Color(settings.globalBackground), tl: 10, tr: 10, bl: 0, br: 0))
            
            HStack {
                Text(loc_about).frame(alignment: .leading).foregroundColor(Color(settings.globalText))
                Spacer()
            }.onTapGesture(perform: {
                showAbout.toggle()
            }).padding(.leading).padding(.trailing)
            Divider()
            HStack {
                Text(loc_gdpr).frame(alignment: .leading).foregroundColor(Color(settings.globalText))
                Spacer()
            }.onTapGesture(perform: {
                showGDPR.toggle()
            }).padding(.leading).padding(.trailing)
            Divider()
            HStack {
                Text(loc_app_version).frame(alignment: .leading).foregroundColor(Color(settings.globalText))
                Spacer()
                Text("\(getCurrentAppBuildVersionString())").frame(alignment: .trailing).foregroundColor(.tixDark)
            }.padding(.leading).padding(.trailing).padding(.bottom)
            
            
        }
        .sheet(isPresented: self.$showAbout) {
            About(settings: settings, show: $showAbout)
        }
        .sheet(isPresented: self.$showGDPR) {
            GDPRView(settings: settings, show: $showGDPR)
        }
        .onAppear(perform: onAppear)
        .background(Color.white)
        .cornerRadius(10)
        .frame(maxWidth: .infinity)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(settings.globalBackground == "White" ? Color.tix : Color(settings.globalForeground), lineWidth: 1).padding(1)
        )
    }
    
    func onAppear() {
        if !MFMailComposeViewController.canSendMail() {
            self.noMail = true
        }
    }
    
    func getCurrentAppBuildVersionString() -> String {
        let versionNumber = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
        let buildString = "\(versionNumber) (\(buildNumber))"
        return String(buildString)
    }
}

