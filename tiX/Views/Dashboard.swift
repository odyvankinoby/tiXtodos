//
//  Dashboard.swift
//  tiX
//
//  Created by Nicolas Ott on 01.11.21.
//

import SwiftUI
import CoreData

struct Dashboard: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: Todo.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Todo.todo, ascending: false)]) var todos: FetchedResults<Todo>
    
    @FetchRequest(entity: Category.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)]) var categories: FetchedResults<Category>
    
    @ObservedObject var settings: UserSettings
    @State private var daySelection = "4"
    @State private var categorySort = ["1", "2", "3", "4", "5", "6", "7"]
    @State private var categorySelected = true
    @State private var cat = Category()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                Text("Hi \(settings.userName)!")
                    .font(.title).bold()
                    .foregroundColor(Color.tix)
                    .frame(alignment: .leading)
                LazyHStack {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(alignment: .top) {
                            Image("AppIcons")
                                .resizable()
                                .cornerRadius(12)
                                .frame(width: 64, height: 64)
                                .frame(alignment: .leading)
                            VStack(alignment: .leading) {
                                Text(loc_welcome).font(.headline).foregroundColor(.white)
                                Text(loc_tix).font(.subheadline).foregroundColor(.white)
                            }.padding()
                            Spacer()
                            Spacer()
                        }
                        Spacer()
                        Spacer()
                    }
                    .padding(.horizontal, 10)
                    .padding(.top, 10)
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity, minHeight: 200, maxHeight: 200)
                .background(Color.tix)
                .cornerRadius(10)
            }.padding()
            
            LazyVStack {
                VStack(alignment: .leading) {
                    Picker(selection: $daySelection, label: Text("blubb")) {
                        ForEach(categorySort, id: \.self) { day in
                            Text(day).foregroundColor(.tix)
                        }
                    }.onChange(of: daySelection, perform: { (value) in
                        //self.updateFilter()
                    })
                        .padding(.bottom)
                        .pickerStyle(SegmentedPickerStyle())
                        .foregroundColor(.tix)
                        .labelsHidden()
                    
                    HStack {
                        Text("Your Todos")
                            .font(.title).bold()
                            .foregroundColor(Color.tix)
                            .frame(alignment: .leading)
                        Spacer()
                        Picker(loc_choose_category, selection: $cat) {
                            ForEach(categories, id: \.self) { catt in
                                HStack {
                                    Text(catt.name ?? "")
                                        .frame(alignment: .leading)
                                        .frame(maxWidth: .infinity)
                                        .foregroundColor(catt.color?.color ?? Color.tix)
                                    
                                    
                                }
                            }
                        }
                        .onChange(of: cat, perform: { (value) in
                            cat = value
                            categorySelected = true
                        })
                        .frame(alignment: .trailing)
                        .padding()
                    }
                    ForEach(todosFiltered, id: \.self) { todo in
                        HStack(alignment: .center){
                            Image(systemName: todo.isDone ? "circle.fill" : "circle")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .onTapGesture {
                                    withAnimation {
                                        ViewContextMethods.isDone(todo: todo, context: viewContext)
                                    }
                                }
                                .foregroundColor(.white)
                                .padding()
                            VStack(alignment: .leading){
                                Text(todo.todo ?? "\(loc_todo)")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                HStack {
                                    Text(todo.hasDueDate ? "\(todo.dueDate!, formatter: itemFormatter)" : "")
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text(todo.todoCategory?.name ?? "")
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                }
                            }
                            Spacer()
                            Image(systemName: todo.important ? "exclamationmark.circle" : "")
                                .foregroundColor(.red)
                            
                        }
                        .padding(.leading).padding(.trailing)
                        .background(Color.tix)
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity)
                    }
                }
            }.padding(.leading).padding(.trailing)
        }.onAppear(perform: onAppear)
    }
    
    func onAppear() {
        let setRequest = NSFetchRequest<Category>(entityName: "Category")
        let setPredicate = NSPredicate(format: "isDefault == true")
        //let setSortDescriptor1 = NSSortDescriptor(keyPath: \Todo.todo, ascending: true)
        setRequest.predicate = setPredicate
        setRequest.fetchLimit = 1
        //setRequest.sortDescriptors = [setSortDescriptor1]
        do {
            let cats = try self.viewContext.fetch(setRequest) as [Category]
            
            for cat in cats {
                self.cat = cat
            }
        } catch let error {
            NSLog("error in FetchRequest trying to get default category: \(error.localizedDescription)")
        }
    }
    
    
    var todosFiltered: [Todo] {
        if categorySelected {
           
            switch settings.hideTicked { //we will need this for our toggle later
            case true:
                return todos.filter {
                    !$0.todo!.isEmpty && $0.isDone == false && $0.todoCategory == cat
                }
            default:
                return todos.filter {
                    !$0.todo!.isEmpty && $0.todoCategory == cat
                }
            }
            
        } else {
            
            switch settings.hideTicked { //we will need this for our toggle later
            case true:
                return todos.filter {
                    !$0.todo!.isEmpty && $0.isDone == false
                }
            default:
                return todos.filter {
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
