//
//  DashboardWelcome.swift
//  tiX
//
//  Created by Nicolas Ott on 17.11.21.
//

import SwiftUI
import EventKit

struct DashboardWelcome: View {
    
    @ObservedObject var settings: UserSettings
    @State var today: Int
    @State var overdue: Int
    @State var unticked: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .center) {
                    Image("\(settings.icon)")
                        .resizable()
                        .cornerRadius(12)
                        .frame(width: 64, height: 64)
                        .frame(alignment: .leading)
                    VStack(alignment: .leading) {
                        Text(loc_welcome).font(.headline).foregroundColor(Color(settings.globalText))
                        Text(loc_tix).font(.subheadline).foregroundColor(Color(settings.globalText))
                    }
                }.padding(.leading).padding(.trailing)
                
                Divider().foregroundColor(.white)
                
                HStack(alignment: .top) {
                    Text(loc_today).font(.headline).foregroundColor(Color(settings.globalText))
                    Spacer()
                    Text("\(today)").font(.subheadline).foregroundColor(Color(settings.globalText))
                }.padding(.leading).padding(.trailing)
                
                HStack(alignment: .top) {
                    Text(loc_overdue).font(.headline).foregroundColor(Color(settings.globalText))
                    Spacer()
                    Text("\(overdue)").font(.subheadline).foregroundColor(Color(settings.globalText))
                    
                }.padding(.leading).padding(.trailing)
                
                HStack(alignment: .top) {
                    Text(loc_open_tasks).font(.headline).foregroundColor(Color(settings.globalText))
                    Spacer()
                    Text("\(unticked)").font(.subheadline).foregroundColor(Color(settings.globalText))
                }.padding(.leading).padding(.trailing)
                
            }
            .frame(maxWidth: .infinity, minHeight: 200, maxHeight: 200)
            .background(Color.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(settings.globalBackground == "White" ? Color.tix : Color(settings.globalForeground), lineWidth: 1).padding(1)
            )
        }
    }
}
