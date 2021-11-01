//
//  About.swift
//  tiX
//
//  Created by Nicolas Ott on 01.11.21.
//

import SwiftUI

struct About: View {
    
    //@ObservedObject var settings: UserSettings
    var body: some View {
        VStack {
            
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .center) {
                    Image("AppIcons")
                        .resizable()
                        .cornerRadius(12)
                        .frame(width: 64, height: 64)
                        .padding(.all, 10)
                        .frame(alignment: .leading)
                    VStack(alignment: .leading) {
                        Text("tiX").font(.headline)
                        Text("track your tasks").font(.subheadline)
                        Text("Version \(getCurrentAppBuildVersionString())").font(.subheadline)
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
                        .font(.largeTitle)
                        .frame(width: 64, height: 64)
                        .padding(.all, 10)
                        .frame(alignment: .leading)
                    VStack(alignment: .leading) {
                        Text("Copyright")
                            .font(.caption)
                        Text("2021 Nicolas Ott").fontWeight(.semibold)
                    }.padding()
                    Spacer()
                }
                HStack(alignment: .center) {
                    Image(systemName: "globe")
                        .font(.largeTitle)
                        .frame(width: 64, height: 64)
                        .padding(.all, 10)
                        .frame(alignment: .leading)
                    VStack(alignment: .leading) {
                        Text("Website")
                            .font(.caption)
                        Text("NicolasOtt.de").fontWeight(.semibold)
                    }.padding()
                    Spacer()
                }
               
                HStack(alignment: .center) {
                    Image(systemName: "at")
                        .font(.largeTitle)
                        .frame(width: 64, height: 64)
                        .padding(.all, 10)
                        .frame(alignment: .leading)
                    VStack(alignment: .leading) {
                        Text("EMail")
                            .font(.caption)
                        Text("tix(at)nicolasott.de").fontWeight(.semibold)
                    }.padding()
                    Spacer()
                }
                
            }.padding(.horizontal, 10)
            .padding(.top, 10)
            .frame(maxWidth: .infinity)
            
            Spacer()
            VStack(alignment: .leading, spacing: 10) {
                
                Text(loc_madewithlove).font(.footnote)
            }
            .padding()
            .padding(.bottom, 25)
            .frame(maxWidth: .infinity)
            
        }
        .accentColor(Color.tix)
        .navigationBarTitle(loc_about, displayMode: .automatic).allowsTightening(true)
    }
    
    
    func getCurrentAppBuildVersionString() -> String {
        let versionNumber = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
        let buildString = "\(versionNumber) (\(buildNumber))"
        return String(buildString)
    }
}


