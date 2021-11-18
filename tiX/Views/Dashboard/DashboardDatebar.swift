//
//  DashboardDatebar.swift
//  tiX
//
//  Created by Nicolas Ott on 17.11.21.
//

import SwiftUI

struct DashboardDatebar: View {
    
    @ObservedObject var settings: UserSettings
    @State private var one = ""
    @State private var two = ""
    @State private var three = ""
    @State private var four = ""
    @State private var five = ""

    var body: some View {
        
        HStack(alignment: .center) {
            HStack(alignment: .center) {
                HStack(alignment: .center) {
                    Spacer()
                    Text("\(one)").frame(alignment: .center).font(.footnote)
                    Spacer()
                }.padding(.top, 5).padding(.bottom, 5).foregroundColor(Color.white).cornerRadius(5)
                
                HStack(alignment: .center) {
                    Spacer()
                    Text(two).frame(alignment: .center).font(.footnote)
                    Spacer()
                }.padding(.top, 5).padding(.bottom, 5).foregroundColor(Color.white).cornerRadius(5)
                
                HStack(alignment: .center) {
                    Spacer()
                    Text(three).frame(alignment: .center).font(.footnote)
                    Spacer()
                }.padding(.top, 5).padding(.bottom, 5).background(Color.white).foregroundColor(Color.tix).cornerRadius(5)
                
                HStack(alignment: .center) {
                    Spacer()
                    Text(four).frame(alignment: .center).font(.footnote)
                    Spacer()
                }.padding(.top, 5).padding(.bottom, 5).foregroundColor(Color.white).cornerRadius(5)
                
                HStack(alignment: .center) {
                    Spacer()
                    Text("\(five)").frame(alignment: .center).font(.footnote)
                    Spacer()
                }.padding(.top, 5).padding(.bottom, 5).foregroundColor(Color.white).cornerRadius(5)
            }.padding(2)
        }
        .padding(.leading)
        .padding(.trailing)
        .background(Color.gray.opacity(0.5))
        .cornerRadius(5)
        .onAppear(perform: onAppear)
        
        
        
    }
    
    func onAppear() {
        
        let today = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: today)
        let dayOfMonth = components.day
        let mComponents = calendar.dateComponents([.month], from: today)
        let month = mComponents.month
        
        let yDate = Date.now.addingTimeInterval(-86400)
        let yComponents = calendar.dateComponents([.day], from: yDate)
        let yesterday = yComponents.day
        
        let yyDate = Date.now.addingTimeInterval(-172800)
        let yyComponents = calendar.dateComponents([.day], from: yyDate)
        let yyesterday = yyComponents.day
        
        let tDate = Date.now.addingTimeInterval(86400)
        let tComponents = calendar.dateComponents([.day], from: tDate)
        let tomorrow = tComponents.day
        
        let ttDate = Date.now.addingTimeInterval(172800)
        let ttComponents = calendar.dateComponents([.day], from: ttDate)
        let ttomorrow = ttComponents.day
        
        one = "\(yyesterday!).\(month!)"
        two = "\(yesterday!).\(month!)"
        three = "\(dayOfMonth!).\(month!)"
        four = "\(tomorrow!).\(month!)"
        five = "\(ttomorrow!).\(month!)"
        
    }
}
