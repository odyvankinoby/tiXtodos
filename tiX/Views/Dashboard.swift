//
//  Dashboard.swift
//  tiX
//
//  Created by Nicolas Ott on 06.10.21.
//

import SwiftUI
import CoreData

struct Dashboard: View {
    
    @Environment(\.managedObjectContext) var viewContext
    
    @Namespace private var namespace
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: false)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    private var todaysItems: [Item] {
        items.filter {
            Calendar.current.isDate($0.dueDate ?? Date(), equalTo: Date(), toGranularity: .day)
        }
    }
    
   
    @State var settingsOpen = false
    @Binding var tabSelected: Int
    
    @AppStorage("userName") var userName = ""
    
    var body: some View {
        ZStack {
            NavigationView {
                ZStack {
                    ScrollView {
                        VStack {
                            HStack {
                                Text("Categories")
                                    .font(.body.smallCaps())
                                    .foregroundColor(.tix)
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(spacing: 20) {
                                    ForEach(categories) {category in
                                        CategoryCards(category: category.category,
                                                      color: category.color,
                                                      numberOfTasks: getTotalTasksNumber(category: category),
                                                      tasksDone: getDoneTasksNumber(category: category))
                                    }
                                    .padding(.bottom, 30)
                                    
                                }
                                .padding(.leading, 20)
                                .padding(.trailing, 30)
                            }
                            .frame(height: 190)
                            
                        }
                        .padding(.top, 30)
                        
                        // MARK: Actual list of todo items
                        VStack {
                            HStack {
                                Text("Today's tasks")
                                    .font(.body.smallCaps())
                                    .foregroundColor(.tix)
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            if todaysItems.count > 0 {
                                LazyVStack(spacing: 10) {
                                    ForEach(todaysItems) { toDoItem in
                                        
                                        // MARK: Today's tasks list view
                                        VStack {
                                            HStack {
                                                Image(systemName: toDoItem.isDone ? "circle.fill" : "circle")
                                                    .resizable()
                                                    .foregroundColor(getCategoryColor(toDoItem: toDoItem))
                                                    .frame(width: 30, height: 30)
                                                    .onTapGesture {
                                                        withAnimation {
                                                            ViewContextMethods.isDone(item: toDoItem, context: viewContext)
                                                        }
                                                    }
                                                    .padding(.leading, 20)
                                                    .padding(.trailing, 10)
                                                
                                                Text("\(toDoItem.toDoText ?? "")")
                                                Spacer()
                                            }
                                        }
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 100)
                                        .background(
                                            ZStack {
                                                getCategoryColor(toDoItem: toDoItem).opacity(0.7)
                                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                    .padding(.horizontal, 30)
                                                    .padding(.vertical, 20)
                                                VStack {
                                                    // empty VStack for the blur
                                                }
                                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 20))
                                            },
                                            alignment: .leading
                                        )
                                        .shadow(color: .black.opacity(0.1), radius: 20, x: 5, y: 10)
                                        .shadow(color: .black.opacity(0.1), radius: 1, x: 1, y: 1)
                                        .shadow(color: .white.opacity(1), radius: 5, x: -1, y: -1)
                                        .padding(.horizontal)
                                        
                                    }
                                }
                                .padding(.bottom, 60)
                            } else {
                                VStack{
                                    Text("No tasks for today")
                                        .foregroundColor(.secondary)
                                }
                                .frame(height: 200)
                            }
                        }
                    }
                    
                    // MARK: Bottom button to add new item
                    VStack{
                        Spacer()
                        HStack{
                            Spacer()
                            Button(action: {
                                withAnimation {
                                    tabSelected = 2
                                }
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .frame(width: 70, height: 70)
                                    .foregroundColor(.tix)
                                    .shadow(color: .indigo.opacity(0.3), radius: 10, x: 0, y: 10)
                                    .padding()
                            }
                        }
                        .matchedGeometryEffect(id: "button", in: namespace)
                    }
                }
                .navigationTitle(userName.isEmpty ? "Hi there!" : "What's up, \(userName)!")
                
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        HStack {
                            Button(action: {
                                withAnimation {
                                    settingsOpen.toggle()
                                 //   Haptics.giveSmallHaptic()
                                }
                                Haptics.giveSmallHaptic()
                            }) {
                                Image(systemName: "gear.circle.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.tix)
                                    //.shadow(color: .tix.opacity(0.3), radius: 10, x: 0, y: 10)
                                    
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                   
                
            }

        }
    }
    
    // MARK: functions
    func getCategoryColor(toDoItem: Item) -> Color {
        var category: [ItemCategory] {
            categories.filter {
                $0.category == toDoItem.category
            }
        }
        
        return category[0].color
    }
    
    func getTotalTasksNumber(category: ItemCategory) -> Int {
        var categoryTasks: [Item] {
            items.filter {
                $0.category == category.category
            }
        }
        
        return categoryTasks.count
    }
    
    func getDoneTasksNumber(category: ItemCategory) -> Int {
        var categoryTasksDone: [Item] {
            items.filter {
                $0.category == category.category && $0.isDone == true
            }
        }
        
        return categoryTasksDone.count
    }
    
}

