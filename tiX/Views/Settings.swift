//
//  Settings.swift
//  tiX
//
//  Created by Nicolas Ott on 09.10.21.
//

import SwiftUI

struct Settings: View {
    
    // Observable Objects
    @ObservedObject var settings: UserSettings
    
    var body: some View {
        
        NavigationView {
            
            ScrollView() {
                
                Text("Settings")
                    .frame(alignment: .leading)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.tix.opacity(0.5))

                Toggle(isOn: $settings.hideTicked) {
                    Text("Hide ticked Todos")
                        .foregroundColor(.tix).frame(alignment: .trailing)
                }.padding(.leading, 10).padding(.trailing, 10)
                
                Divider()
                
                Toggle(isOn: $settings.deleteTicked) {
                        Text("Delete ticked Todos")
                            .foregroundColor(.tix).frame(alignment: .trailing)
                }.padding(.leading, 10).padding(.trailing, 10)

            }
            .frame(maxWidth: .infinity)
            .background(Color(UIColor.systemBackground))
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.tix.opacity(0.5), lineWidth: 0.5))
            .padding()
            .navigationBarTitle("Settings", displayMode: .automatic).allowsTightening(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor(.tix) // NAV
    }
}


