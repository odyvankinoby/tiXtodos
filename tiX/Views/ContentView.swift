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
        
        // Segmented Picker
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(named: "tix")
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(named: "tix") ?? Color.black], for: .normal)
        
    }
    // Observable Objects
    @ObservedObject var settings = UserSettings()
    
    @FetchRequest(entity: Category.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)], predicate: NSPredicate(format: "isDefault == true")) var categories: FetchedResults<Category>
    
    // Navigation
    @State var tabSelected: Int = 1
    
    @State private var showSetup = false
    
    var body: some View {
       
        TabView(selection: $tabSelected) {
            Dashboard(settings: settings)
                .tabItem {
                    Image(systemName: "house")
                    //Text(loc_dashboard)
                }.tag(1)
            Todos(settings: settings)
                .tabItem {
                    Image(systemName: "list.bullet")
                    //Text(loc_todos)
                }.tag(2)
            Cats(settings: settings)
                .tabItem {
                    Image(systemName: "folder")
                    //Text(loc_categories)
                }.tag(3)
            Settings(settings: settings)
                .tabItem {
                    Image(systemName: "gear")
                    //Text(loc_settings)
                }.tag(4)
        }
        .sheet(isPresented: self.$showSetup) {
            SetupView(settings: settings)
         }
        .accentColor(Color.tix)
        .onAppear(perform: onAppear)
       }
    
    func onAppear() {
        let launchedBefore = settings.launchedBefore
        if launchedBefore {
            settings.launchedBefore = true
            self.showSetup = false
        } else {
            self.showSetup = true
        }
        
        if categories.count == 0 {
            let newC = Category(context: self.viewContext)
            newC.name = "Inbox"
            newC.isDefault = true
            newC.color = SerializableColor(from: Color.tix)
            newC.id = UUID()
            do {
                try self.viewContext.save()
            } catch {
                NSLog(error.localizedDescription)
            }
        }
    }
}

