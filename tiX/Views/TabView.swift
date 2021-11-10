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
    @ObservedObject var settings = UserSettings()
    let coloredNavAppearance = UINavigationBarAppearance()
    
    init() {
        // Segmented Picker
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.white)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(named: "tix") ?? Color.black], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(named: "tixDark") ?? Color.black], for: .normal)
        // TextEditor
        UITextView.appearance().backgroundColor = .clear
    }
    
    
    @FetchRequest(entity: Category.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)], predicate: NSPredicate(format: "isDefault == true")) var categories: FetchedResults<Category>
    
    // Navigation
    @State var tabSelected: Int = 1
    @State var showSheet = false
    @State var showSetup = false
    @State var showUpdate = false
    
    var body: some View {
       
        TabView(selection: $tabSelected) {
            Dashboard(settings: settings, tabSelected: $tabSelected)
                .tabItem {}.tag(1)
            Todos(settings: settings)
                .tabItem {}.tag(2)
            Categories(settings: settings, tabSelected: $tabSelected)
                .tabItem {}.tag(3)
            Settings(settings: settings, tabSelected: $tabSelected)
                .tabItem {}.tag(4)
        }
        .edgesIgnoringSafeArea(.all)
        .tabViewStyle(PageTabViewStyle())
        
        .sheet(isPresented: self.$showSheet) {
            if self.showSetup {
                SetupView(settings: settings)
            } else if self.showUpdate {
                UpdateView(settings: settings)
            }
        }
        .accentColor(Color.white)
        .onAppear(perform: onAppear)
    }
    
    func onAppear() {
       
        // Launched Before
        print("settings.launchedbefore = \(settings.launchedBefore)")
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
       
        // Show Update Screen
        let newVersion = getCurrentAppVersion()
        let newBuild = getCurrentAppBuildVersion()
        let newAppBuildString = getCurrentAppBuildVersionString()
        
        let savedVersion = settings.appVersion
        let savedBuild = settings.appBuild
       
        settings.appVersion = newVersion
        settings.appBuild = newBuild
        settings.appVersionString = newAppBuildString
      
        if launchedBefore {
            if savedVersion != newVersion || savedBuild != newBuild {
                self.showUpdate = true
                self.showSheet = true
            }
        } else {
            self.showSetup = true
            self.showSheet = true
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
    
    // Get current Version of the App
    func getCurrentAppVersion() -> String {
        let versionNumber = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        return String(versionNumber)
    }
    
    func getCurrentAppBuildVersion() -> String {
        let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
        return String(buildNumber)
    }
    
    func getCurrentAppBuildVersionString() -> String {
        let versionNumber = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
        let buildString = "\(versionNumber) (\(buildNumber))"
        return String(buildString)
    }
}

