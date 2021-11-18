//
//  ContentView.swift
//  tiX
//
//  Created by Nicolas Ott on 05.10.21.
//

import SwiftUI
import CoreData
import StoreKit

struct TabViewView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var settings = UserSettings()
    
    let productIDs = [
        "de.nicolasott.tiX.premium"
    ]
    @StateObject var storeManager = StoreManager()

    // Navigation
    @State var tabSelected: Int = 1
    @State var showSheet = false
    @State var showSetup = false
    @State var showUpdate = false
    
    // Category
    @State var dc = DefaultCategory()
    
    var body: some View {
       
        TabView(selection: $tabSelected) {
            Dashboard(settings: settings, storeManager: storeManager, dc: dc, tabSelected: $tabSelected)
                .environment(\.managedObjectContext, viewContext)
                .tabItem {}.tag(1)
            Todos(settings: settings, dc: dc, tabSelected: $tabSelected)
                .environment(\.managedObjectContext, viewContext)
                .tabItem {}.tag(2)
            Categories(settings: settings, storeManager: storeManager, tabSelected: $tabSelected).environment(\.managedObjectContext, viewContext)
                .tabItem {}.tag(3)
            Settings(settings: settings, storeManager: storeManager, tabSelected: $tabSelected).environment(\.managedObjectContext, viewContext)
                .tabItem {}.tag(4)
        }
        .edgesIgnoringSafeArea(.all)
        .tabViewStyle(PageTabViewStyle())
        .sheet(isPresented: self.$showSheet) {
            if self.showSetup {
                SetupView(settings: settings).environment(\.managedObjectContext, viewContext)
            } else if self.showUpdate {
                UpdateView(settings: settings).environment(\.managedObjectContext, viewContext)
            }
        }
        .background(Color(settings.globalBackground))
        .accentColor(Color(settings.globalForeground))
        .onAppear(perform: onAppear)
     
    }
    
    func onAppear() {
        
        //settings.purchased = true
        
        
        SKPaymentQueue.default().add(storeManager)
        storeManager.getProducts(productIDs: productIDs)
        
        dc.getDefault(viewContext: viewContext)
    
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
                // Update from 1.1 => Newer
                if settings.globalBackground == "White" {
                    settings.globalForeground = "tix"
                    settings.globalText = "tix"
                    settings.icon = "AppIcons"
                }
            }
        } else {
            self.showSetup = true
            self.showSheet = true
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

