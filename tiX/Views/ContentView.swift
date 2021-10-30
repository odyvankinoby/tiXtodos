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
    }
    
    
    // Observable Objects
    @ObservedObject var settings = UserSettings()
    @FetchRequest(entity: Category.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)], predicate: NSPredicate(format: "isDefault == true")) var categories: FetchedResults<Category>
    // Navigation
    @State var tabSelected: Int = 1
    
    var body: some View {
     
        TabView(selection: $tabSelected) {
            Today(settings: settings)
                .tabItem {
                    Image(systemName: "calendar")
                    //Text("Todos")
                }.tag(1)
            Todos(settings: settings)
                .tabItem {
                    Image(systemName: "list.bullet")
                    //Text("Todos")
                }.tag(2)
            Cats(settings: settings)
                .tabItem {
                    Image(systemName: "folder")
                    //Text("Categories")
                }.tag(3)
            Settings(settings: settings)
                .tabItem {
                    Image(systemName: "gear")
                    //Text("Settings")
                }.tag(4)
            
        }
        //.tabViewStyle(PageTabViewStyle())
        .accentColor(Color.tix)
        .onAppear(perform: onAppear)
    }
    func onAppear() {
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

