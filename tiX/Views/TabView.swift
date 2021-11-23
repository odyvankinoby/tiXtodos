//
//  ContentView.swift
//  tiX
//
//  Created by Nicolas Ott on 05.10.21.
//

import SwiftUI
import CoreData
import StoreKit
import EventKit

struct TabViewView: View {
    
    @Environment(\.managedObjectContext) var viewContext
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
    @State var defaultCat = Category()
    
    // Calendar
    @State var eventStore = EKEventStore()
    @State var calEvents = [EKEvent]()
    
    var body: some View {
       
        TabView(selection: $tabSelected) {
            Dashboard(settings: settings, storeManager: storeManager, calEvents: $calEvents, defaultCat: defaultCat, tabSelected: $tabSelected)
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
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            if settings.showEvents {
                getEvents()
            }
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
    
    func getEvents() {
        
        eventStore.requestAccess(to: .event) { (granted, error) in
            if granted {
                DispatchQueue.main.async {
                    let today = Date().midnight
                    var dateComps = DateComponents()
                    dateComps.day = 1
                    let endDate = Calendar.current.date(byAdding: dateComps, to: today)
                    let predicate = self.eventStore.predicateForEvents(withStart: today, end: endDate ?? Date(), calendars: nil)
                    self.calEvents = self.eventStore.events(matching: predicate)
                    
                }
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
    
    
    func getDefault() {
        let setRequest = NSFetchRequest<Category>(entityName: "Category")
        let setPredicate = NSPredicate(format: "isDefault == true")
        let setSortDescriptor1 = NSSortDescriptor(keyPath: \Category.timestamp, ascending: false)
        setRequest.predicate = setPredicate
        setRequest.sortDescriptors = [setSortDescriptor1]
        do {
            let cats = try viewContext.fetch(setRequest) as [Category]
            if cats.count > 1 {
                print("Merging Inboxes")
                for first in cats {
                    mergeInbox(first: first)
                    mergeEmpty(first: first)
                    self.defaultCat = first
                    
                }
            } else if cats.count == 1 {
                for cat in cats {
                    mergeEmpty(first: cat)
                    self.defaultCat = cat
                    
                }
            } else {
                createInbox()
            }
        } catch let error {
            NSLog("error in FetchRequest trying to get default category: \(error.localizedDescription)")
        }
    }
    
    private func mergeInbox(first: Category) {
        
        let setRequest = NSFetchRequest<Category>(entityName: "Category")
        let setPredicate = NSPredicate(format: "isDefault == true")
        let setSortDescriptor1 = NSSortDescriptor(keyPath: \Category.timestamp, ascending: false)
        setRequest.predicate = setPredicate
        setRequest.sortDescriptors = [setSortDescriptor1]
        do {
            let inboxes = try viewContext.fetch(setRequest) as [Category]
            for cat in inboxes {
                if cat != first {
                    let tdR = NSFetchRequest<Todo>(entityName: "Todo")
                    let tdrPred = NSPredicate(format: "todoCategory == %@", first as CVarArg)
                    tdR.predicate = tdrPred
                    do {
                        let mergeTodos = try viewContext.fetch(tdR) as [Todo]
                        for td in mergeTodos {
                            td.todoCategory = first
                            do {
                                try viewContext.save()
                            } catch {
                                NSLog(error.localizedDescription)
                            }
                        }
                    }
                    catch let error {
                        NSLog("error in FetchRequest trying to get todos in default category to be merged: \(error.localizedDescription)")
                    }
                    viewContext.delete(cat)
                    do {
                        try viewContext.save()
                    } catch {
                        NSLog(error.localizedDescription)
                    }
                }
            }
        }
        catch let error {
            NSLog("error in FetchRequest trying to get default category: \(error.localizedDescription)")
        }
    }
    
    private func createInbox() {

        let newC = Category(context: viewContext)
        newC.name = "Inbox"
        newC.isDefault = true
        newC.timestamp = Date()
        newC.color = SerializableColor(from: Color.tix)
        newC.id = UUID()
        do {
            try viewContext.save()
            self.defaultCat = newC
            
        } catch {
            NSLog(error.localizedDescription)
        }
    }

    private func mergeEmpty(first: Category) {
        
        let tdR = NSFetchRequest<Todo>(entityName: "Todo")
        let tdrPred = NSPredicate(format: "todoCategory == nil")
        tdR.predicate = tdrPred
        do {
            let mergeTodos = try viewContext.fetch(tdR) as [Todo]
            for td in mergeTodos {
                td.todoCategory = first
                do {
                    try viewContext.save()
                } catch {
                    NSLog(error.localizedDescription)
                }
            }
        }
        catch let error {
            NSLog("error in FetchRequest trying to get todos in default category to be merged: \(error.localizedDescription)")
        }
    }
}

