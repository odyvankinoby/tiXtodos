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
            tiX(settings: settings)
                .tabItem {
                    Image(systemName: "list.bullet.circle.fill")
                    Text("Todos")
                }.tag(1)
            NewItem(tabSelected: $tabSelected)
                .tabItem {
                    Image(systemName: "plus")
                    Text("New")
                }.tag(2)
            
        }
        .accentColor(Color.indigo)
    }
}

