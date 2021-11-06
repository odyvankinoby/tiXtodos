//
//  ContentView.swift
//  tiX
//
//  Created by Nicolas Ott on 05.10.21.
//

import SwiftUI
import CoreData

struct TabViewView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    let coloredNavAppearance = UINavigationBarAppearance()
    
    init() {
        coloredNavAppearance.titleTextAttributes = [.foregroundColor: UIColor(.tix)]
        coloredNavAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(.tix)]
        coloredNavAppearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(.tix)]
        UINavigationBar.appearance().standardAppearance = coloredNavAppearance
        UINavigationBar.appearance().barTintColor = UIColor(.tix)
        
        // Segmented Picker
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(named: "tixDark")
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(named: "tixDark") ?? Color.black], for: .normal)
        
    }
    // Observable Objects
    @ObservedObject var settings = UserSettings()
    
    @FetchRequest(entity: Category.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)], predicate: NSPredicate(format: "isDefault == true")) var categories: FetchedResults<Category>
    
    // Navigation
    @State var tabSelected: Int = 1
    
    @State var showSetup = false
    
    var body: some View {
       
        TabView(selection: $tabSelected) {
            Dashboard(settings: settings, tabSelected: $tabSelected)
                .tabItem {
                    //Image(systemName: "house")
                }.tag(1)
            Todos(settings: settings)
                .tabItem {
                    //Image(systemName: "list.bullet")
                }.tag(2)
            Cats(settings: settings, tabSelected: $tabSelected)
                .tabItem {
                    //Image(systemName: "folder")
                }.tag(3)
            Settings(settings: settings, tabSelected: $tabSelected)
                .tabItem {
                    //Image(systemName: "gear")
                }.tag(4)
        }
        .edgesIgnoringSafeArea(.all)
        .tabViewStyle(PageTabViewStyle())
        .sheet(isPresented: self.$showSetup) {
            SetupView(settings: settings)
         }
        .accentColor(Color.white)
        .onAppear(perform: onAppear)
    }
    
    func onAppear() {
       
        print("settings.launchedbefore = \(settings.launchedBefore)")
        
        if settings.launchedBefore {
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

