//
//  About.swift
//  tiX
//
//  Created by Nicolas Ott on 01.11.21.
//

import SwiftUI

struct About: View {
    
    @ObservedObject var settings: UserSettings
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .center) {
                    Image("AppIcons")
                        .resizable()
                        .cornerRadius(12)
                        .frame(width: 64, height: 64)
                        .padding(.all, 10)
                        .frame(alignment: .leading)
                    VStack(alignment: .leading) {
                        Text("tiX").font(.headline).foregroundColor(.white)
                        Text("track your tasks").font(.subheadline).foregroundColor(.white)
                        Text("Version \(getCurrentAppBuildVersionString())").font(.subheadline).foregroundColor(.white)
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
                        .font(.largeTitle).foregroundColor(.white)
                        .frame(width: 64, height: 64)
                        .padding(.all, 10)
                        .frame(alignment: .leading)
                    VStack(alignment: .leading) {
                        Text("Copyright")
                            .font(.caption).foregroundColor(.white)
                        Text("2021 Nicolas Ott").fontWeight(.semibold).foregroundColor(.white)
                    }.padding()
                    Spacer()
                }
                HStack(alignment: .center) {
                    Image(systemName: "globe")
                        .font(.largeTitle).foregroundColor(.white)
                        .frame(width: 64, height: 64)
                        .padding(.all, 10)
                        .frame(alignment: .leading)
                    VStack(alignment: .leading) {
                        Text("Website")
                            .font(.caption).foregroundColor(.white)
                        Text("NicolasOtt.de").fontWeight(.semibold).foregroundColor(.white)
                    }.padding()
                    Spacer()
                }
               
                HStack(alignment: .center) {
                    Image(systemName: "at")
                        .font(.largeTitle).foregroundColor(.white)
                        .frame(width: 64, height: 64)
                        .padding(.all, 10)
                        .frame(alignment: .leading)
                    VStack(alignment: .leading) {
                        Text("EMail").font(.caption).foregroundColor(.white)
                        Text("tix(at)nicolasott.de").fontWeight(.semibold).foregroundColor(.white)
                    }.padding()
                    Spacer()
                }
                
            }.padding(.horizontal, 10)
            .padding(.top, 10)
            .frame(maxWidth: .infinity)
            
            Spacer()
            Spacer()
            Spacer()
            VStack(alignment: .leading, spacing: 10) {
                Text(loc_madewithlove).font(.footnote).foregroundColor(.white)
            }
            .padding()
            .padding(.bottom, 25)
            .frame(maxWidth: .infinity)
        }
        .accentColor(Color.white)
        .background(Color(settings.globalBackground))
    }
    
    
    func getCurrentAppBuildVersionString() -> String {
        let versionNumber = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
        let buildString = "\(versionNumber) (\(buildNumber))"
        return String(buildString)
    }
}


