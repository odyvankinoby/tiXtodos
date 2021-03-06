//
//  About.swift
//  tiX
//
//  Created by Nicolas Ott on 01.11.21.
//

import SwiftUI

struct About: View {
    
    @ObservedObject var settings: UserSettings
    @Binding var show: Bool
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    withAnimation {
                        show = false
                    }
                }) {
                    Text(loc_discard)
                        .foregroundColor(Color(settings.globalForeground))
                }
                .buttonStyle(PlainButtonStyle())
            }.padding(.top).padding(.bottom)
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    HStack(alignment: .center) {
                        Image("\(settings.icon)")
                            .resizable()
                            .cornerRadius(12)
                            .frame(width: 64, height: 64)
                            .frame(alignment: .leading)
                            .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(settings.icon == "IconWhite" ? Color(settings.globalForeground) : Color.white, lineWidth: 1)
                                )
                        VStack(alignment: .leading) {
                            Text("tiX").font(.headline).foregroundColor(Color(settings.globalForeground))
                            Text("track your tasks").font(.subheadline).foregroundColor(Color(settings.globalForeground))
                            Text("Version \(getCurrentAppBuildVersionString())").font(.subheadline).foregroundColor(Color(settings.globalForeground))
                        }.padding()
                        Spacer()
                    }
                }
                .padding(.horizontal, 10)
                .padding(.top, 10)
                .frame(maxWidth: .infinity)
                
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack(alignment: .center) {
                        Image(systemName: "c.circle")
                            .font(.largeTitle).foregroundColor(Color(settings.globalForeground))
                            .frame(width: 64, height: 64)
                            .padding(.all, 10)
                            .frame(alignment: .leading)
                        VStack(alignment: .leading) {
                            Text("Copyright")
                                .font(.caption).foregroundColor(Color(settings.globalForeground))
                            Text("2021 Nicolas Ott").fontWeight(.semibold).foregroundColor(Color(settings.globalForeground))
                        }.padding()
                        Spacer()
                    }
                    HStack(alignment: .center) {
                        Image(systemName: "globe")
                            .font(.largeTitle).foregroundColor(Color(settings.globalForeground))
                            .frame(width: 64, height: 64)
                            .padding(.all, 10)
                            .frame(alignment: .leading)
                        VStack(alignment: .leading) {
                            Text("Website")
                                .font(.caption).foregroundColor(Color(settings.globalForeground))
                            Text("NicolasOtt.de").fontWeight(.semibold).foregroundColor(Color(settings.globalForeground))
                        }.padding()
                        Spacer()
                    }
                   
                    HStack(alignment: .center) {
                        Image(systemName: "at")
                            .font(.largeTitle).foregroundColor(Color(settings.globalForeground))
                            .frame(width: 64, height: 64)
                            .padding(.all, 10)
                            .frame(alignment: .leading)
                        VStack(alignment: .leading) {
                            Text("EMail").font(.caption).foregroundColor(Color(settings.globalForeground))
                            Text("support(at)nicolasott.de").fontWeight(.semibold).foregroundColor(Color(settings.globalForeground))
                        }.padding()
                        Spacer()
                    }
                    
                }
                .padding(.horizontal, 10)
                .padding(.top, 10)
                .frame(maxWidth: .infinity)
                
                Spacer()
                Spacer()
                Spacer()
                VStack(alignment: .leading, spacing: 10) {
                    Text(loc_madewithlove).font(.footnote).foregroundColor(Color(settings.globalForeground))
                }
                .padding()
                .padding(.bottom, 25)
                .frame(maxWidth: .infinity)
            }
        
        }
        .padding(.leading)
        .padding(.trailing)
        .accentColor(Color(settings.globalForeground))
        .background(Color(settings.globalBackground))
    }
    
    
    func getCurrentAppBuildVersionString() -> String {
        let versionNumber = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
        let buildString = "\(versionNumber) (\(buildNumber))"
        return String(buildString)
    }
}


