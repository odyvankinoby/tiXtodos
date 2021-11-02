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
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(named: "tixDark") ?? Color.black], for: .normal)
        
    }
    // Observable Objects
    @ObservedObject var settings = UserSettings()
    
    @FetchRequest(entity: Category.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)], predicate: NSPredicate(format: "isDefault == true")) var categories: FetchedResults<Category>
    
    // Navigation
    @State var tabSelected: Int = 0
    
    @State private var showSetup = false
    
    var body: some View {
       
        TabView(selection: $tabSelected) {
            Dashboard(settings: settings)
                .tabItem {
                    Image(systemName: "house")
                    //Text("Todos")
                }.tag(0)
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
        .sheet(isPresented: self.$showSetup) {
            SetupView(settings: settings)
         }
        .accentColor(Color.tix)
        .onAppear(perform: onAppear)
    /*.overlay( // Overlay the custom TabView component here
        
        
        LinearGradient(gradient: Gradient(colors: [.orange, .red, .red]), startPoint: .topTrailing, endPoint: .bottomLeading)
            // Base color for Tab Bar
                    .edgesIgnoringSafeArea(.vertical)
                    .shadow(color: .gray.opacity(0.4), radius: 2, x: 0, y: 1)
                    //.padding()
                    .frame(height: 50) // Match Height of native bar
                    .overlay(HStack {
                        Spacer()

                        // First Tab Button
                        Button(action: {
                            self.tabSelected = 0
                        }, label: {
                            Image(systemName: "house.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25, alignment: .center)
                                .foregroundColor(.white)
                                .opacity(tabSelected == 0 ? 1 : 0.4)
                        })
                        Spacer()

                        // Second Tab Button
                        Button(action: {
                            self.tabSelected = 1
                        }, label: {
                            Image(systemName: "heart.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25, alignment: .center)
                                .foregroundColor(.white)
                                .opacity(tabSelected == 1 ? 1 : 0.4)
                        })

                        Spacer()
// Third Tab Button
                        Button(action: {
                            self.tabSelected = 2
                        }, label: {
                            Image(systemName: "house")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25, alignment: .center)
                                .foregroundColor(.white)
                                .opacity(tabSelected == 2 ? 1 : 0.4)
                        })
                        Spacer()

                    }), alignment: .bottom) // Align the overlay to bottom to ensure tab bar stays pinned.*/
    }
    
    func onAppear() {
        
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        
        if launchedBefore {
            /*if savedVersion != newVersion || savedBuild != newBuild {
                self.update = true
                self.showSheet = true
            }*/
            self.showSetup = false
        } else {
            self.showSetup = false
            //self.showSheet = true
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

