//
//  Dashboard.swift
//  tiX
//
//  Created by Nicolas Ott on 01.11.21.
//

import SwiftUI
import Foundation
import CoreData
import EventKit

struct Dashboard: View {
    
    @Environment(\.managedObjectContext) var viewContext
    
    @FetchRequest(entity: Todo.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Todo.todo, ascending: false)]) var items: FetchedResults<Todo>
    
    @FetchRequest(entity: Todo.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Todo.todo, ascending: false)], predicate: NSPredicate(format: "dueDate < %@", Date().midnight as CVarArg)) var overdue: FetchedResults<Todo>
    
    @FetchRequest(entity: Todo.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Todo.todo, ascending: false)], predicate: NSPredicate(format: "dueDate >= %@", Date().midnight as CVarArg)) var today: FetchedResults<Todo>
    
    @FetchRequest(entity: Todo.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Todo.todo, ascending: false)], predicate: NSPredicate(format: "isDone == %@", false as CVarArg)) var unticked: FetchedResults<Todo>
    
    @FetchRequest(entity: Category.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: false)]) var categories: FetchedResults<Category>
    
    @ObservedObject var settings: UserSettings
    @StateObject var storeManager: StoreManager
    @Binding var calEvents: [EKEvent]
    
    //@State var dc: DefaultCategory
    @State var dc = DefaultCategory()
    
    @State var defaultCat: Category
    
    @Binding var tabSelected: Int
    
    @State private var categorySelected = true
    @State private var cat = Category()
    @State private var buy = false
        
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    withAnimation {
                        self.tabSelected = 2
                    }
                }) {
                    Image(systemName: "list.bullet.circle")
                        .foregroundColor(Color(settings.globalForeground))
                        .font(.title)
                        .padding(.top)
                }
                Spacer()
                if settings.purchased == false {
                    Button(action: {
                        withAnimation {
                            buy.toggle()
                        }
                    }) {
                        Image(systemName: "crown")
                            .foregroundColor(Color(settings.globalForeground))
                            .font(.title)
                            .padding(.top)
                    }
                }
                Button(action: {
                    withAnimation {
                        self.tabSelected = 4
                    }
                }) {
                    Image(systemName: "gear")
                        .foregroundColor(Color(settings.globalForeground))
                        .font(.title)
                        .padding(.top)
                }
                Button(action: {
                    withAnimation {
                        dc.getDefault(viewContext: viewContext)
                    }
                }) {
                    Image(systemName: "arrow.down.forward.and.arrow.up.backward.circle")
                        .foregroundColor(Color(settings.globalForeground))
                        .font(.title)
                        .padding(.top)
                }
            }
            
            HStack {
                Text("Hi \(settings.userName)!")
                    .font(.title).bold()
                    .foregroundColor(Color(settings.globalForeground))
                    .frame(alignment: .leading)
                    .padding(.top, 5)
                Spacer()
            }
            
            ScrollView {
                if settings.showWelcome {
                    DashboardWelcome(settings: settings, today: today.count, overdue: overdue.count, unticked: unticked.count)
                }
                
                LazyVStack {
                    VStack(alignment: .leading) {
                        
                        DashboardDatebar(settings: settings)
                        
                        HStack {
                            Text(loc_your_todos)
                                .font(.title).bold()
                                .foregroundColor(Color(settings.globalForeground))
                                .frame(alignment: .leading)
                            
                            Spacer()
                            Picker(loc_choose_category, selection: $cat) {
                                ForEach(categories, id: \.self) { catt in
                                    HStack {
                                        Text("\(catt.name ?? "") (\(catt.todo?.count ?? 0))")
                                            .frame(alignment: .leading)
                                            .frame(maxWidth: .infinity)
                                            .foregroundColor(Color(settings.globalForeground))
                                            .font(.body)
                                    }
                                }
                            }
                            .onChange(of: cat, perform: { (value) in
                                cat = value
                                categorySelected = true
                            })
                            .frame(alignment: .trailing)
                            .padding(.leading)
                            .padding(.trailing)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(settings.globalBackground == "White" ? Color.tix : Color(settings.globalForeground), lineWidth: 1).padding(1)
                            )
                            
                        }.padding(.trailing, 1).padding(.top, 5)
                        
                        if settings.showEvents {
                            DashboardCalendar(settings: settings, calEvents: $calEvents)
                        }
                        
                        ForEach(todosFiltered, id: \.self) { todo in
                            HStack(alignment: .center) {
                                Image(systemName: todo.isDone ? "circle.fill" : "circle")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .onTapGesture {
                                        withAnimation {
                                            ViewContextMethods.isDone(todo: todo, context: viewContext)
                                        }
                                    }
                                    .foregroundColor(Color(settings.globalText).opacity(todo.isDone ? 0.5 : 1))
                                    .padding(.trailing, 10)
                                    .padding(.bottom)
                                    .padding(.top)
                                VStack(alignment: .leading){
                                    HStack {
                                        Text(todo.todo ?? "\(loc_todo)")
                                            .font(.headline)
                                            .foregroundColor(Color(settings.globalText).opacity(todo.isDone ? 0.5 : 1))
                                        
                                        Spacer()
                                        if todo.important {
                                            Image(systemName: "exclamationmark.circle")
                                                .font(.headline)
                                                .foregroundColor(Color.red.opacity(todo.isDone ? 0.5 : 1))
                                        }
                                    }
                                    HStack {
                                        Text(todo.hasDueDate ? "\(todo.dueDate!, formatter: itemFormatter)" : "")
                                            .font(.subheadline)
                                            .foregroundColor(Color(settings.globalText).opacity(todo.isDone ? 0.5 : 1))
                                        Spacer()
                                        Text(todo.todoCategory?.name ?? "")
                                            .font(.subheadline)
                                            .foregroundColor(Color(settings.globalText).opacity(todo.isDone ? 0.5 : 1))
                                    }
                                }
                                
                                
                            }
                            .padding(.leading).padding(.trailing)
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(settings.globalBackground == "White" ? Color.tix : Color(settings.globalForeground), lineWidth: 1).padding(1)
                            )
                            .frame(maxWidth: .infinity)
                            
                        }
                    }
                }.padding(.top, 5)
            }
        }
        .sheet(isPresented: $buy) {
            InAppPurchase(settings: settings, storeManager: storeManager)
        }
        .accentColor(Color(settings.globalForeground))
        .padding(.leading).padding(.trailing)
        .background(Color(settings.globalBackground))
        .onAppear(perform: onAppear)
    }
    

    func onAppear() {
        //settings.purchased = true
        self.cat = defaultCat // dc.defaultCategory
        WidgetUpdater().getSetValues(viewContext: viewContext)
    }
    
    
    var todosFiltered: [Todo] {
        if categorySelected {
            
            switch settings.hideTicked { //we will need this for our toggle later
            case true:
                return items.filter {
                    !$0.todo!.isEmpty && $0.isDone == false && $0.todoCategory == cat
                }
            default:
                return items.filter {
                    !$0.todo!.isEmpty && $0.todoCategory == cat
                }
            }
            
        } else {
            
            switch settings.hideTicked { //we will need this for our toggle later
            case true:
                return items.filter {
                    !$0.todo!.isEmpty && $0.isDone == false
                }
            default:
                return items.filter {
                    !$0.todo!.isEmpty
                }
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()

