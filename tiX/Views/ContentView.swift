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
    let coloredNavAppearance = UINavigationBarAppearance()
    
    init() {
        
      
        coloredNavAppearance.titleTextAttributes = [.foregroundColor: UIColor(.tix)]
        
        coloredNavAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(.tix)]
        coloredNavAppearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(.tix)]
        
        UINavigationBar.appearance().standardAppearance = coloredNavAppearance
        UINavigationBar.appearance().barTintColor = UIColor(.tix)
        //UINavigationBar.appearance().scrollEdgeAppearance = coloredNavAppearance
     
    }
    
    
    // Observable Objects
    @ObservedObject var settings = UserSettings()
    
    // Navigation
    @State var tabSelected: Int = 0
    
    var body: some View {
     
        TabView(selection: $tabSelected) {
            /*Dashboard(tabSelected: $tabSelected)
                .tabItem {
                    Image(systemName: "house.circle")
                    Text("Dashboard")
                }.tag(0)
            */
            Todos(settings: settings)
                .tabItem {
                    Image(systemName: "list.bullet.circle")
                    Text("Todos")
                }.tag(1)
            Cats(settings: settings)
                .tabItem {
                    Image(systemName: "folder.circle")
                    Text("Categories")
                }.tag(1)
            Settings(settings: settings)
                .tabItem {
                    Image(systemName: "gear.circle.fill")
                    Text("Settings")
                }.tag(2)
            
        }
        .accentColor(Color.tix)
    }
}

