//
//  ContentView.swift
//  tiX
//
//  Created by Nicolas Ott on 05.10.21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    // Observable Objects
    @ObservedObject var settings = UserSettings()
    
    // Navigation
    @State var tabSelected: Int = 0
    
    var body: some View {
        TabView(selection: $tabSelected) {
            Dashboard(tabSelected: $tabSelected)
                .tabItem {
                    Image(systemName: "house.circle")
                    Text("Dashboard")
                }.tag(0)
            Items(settings: settings)
                .tabItem {
                    Image(systemName: "list.bullet.circle")
                    Text("Todos")
                }.tag(1)
            NewItem()
                .tabItem {
                    Image(systemName: "plus.circle")
                    Text("New Item")
                }.tag(2)
            Settings(settings: settings)
                .tabItem {
                    Image(systemName: "gear.circle.fill")
                    Text("Settings")
                }.tag(3)
            
        }
        .accentColor(Color.tix)
    }
}

