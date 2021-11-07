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
    
    @FetchRequest(entity: Todo.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Todo.todo, ascending: false)]) var items: FetchedResults<Todo>
    
    @FetchRequest(entity: Todo.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Todo.todo, ascending: false)], predicate: NSPredicate(format: "dueDate < %@", Date().midnight as CVarArg)) var overdue: FetchedResults<Todo>
    
    @FetchRequest(entity: Todo.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Todo.todo, ascending: false)], predicate: NSPredicate(format: "dueDate >= %@", Date().midnight as CVarArg)) var today: FetchedResults<Todo>
    
    @FetchRequest(entity: Todo.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Todo.todo, ascending: false)], predicate: NSPredicate(format: "isDone == false")) var open: FetchedResults<Todo>
    
    @FetchRequest(entity: Category.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: false)]) var categories: FetchedResults<Category>
    
    @ObservedObject var settings: UserSettings
    @Binding var tabSelected: Int
    
    @State private var daySelection = "1"
    @State private var categorySort = ["1"]
    @State private var categorySelected = true
    @State private var cat = Category()
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    withAnimation {
                        self.tabSelected = 4
                    }
                }) {
                    Image(systemName: "gear").foregroundColor(.white).font(.title2)
                }
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
                Button(action: {
                    withAnimation {
                        self.tabSelected = 2
                    }
                }) {
                    Image(systemName: "list.bullet").foregroundColor(.white).font(.title2)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            HStack {
                Text("Hi \(settings.userName)!")
                    .font(.title).bold()
                    .foregroundColor(Color.white)
                    .frame(alignment: .leading)
                    .padding(.top)
                Spacer()
                
            }
            
            ScrollView {
                VStack(alignment: .leading) {
                 
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(alignment: .center) {
                            Image("AppIcons")
                                .resizable()
                                .cornerRadius(12)
                                .frame(width: 64, height: 64)
                                .frame(alignment: .leading)
                            VStack(alignment: .leading) {
                                Text(loc_welcome).font(.headline).foregroundColor(.tix)
                                Text(loc_tix).font(.subheadline).foregroundColor(.tix)
                            }
                        }.padding(.leading).padding(.trailing)
                        
                        Divider().foregroundColor(.white)
                        
                        HStack(alignment: .top) {
                            Text(loc_today).font(.headline).foregroundColor(.tix)
                            Spacer()
                            Text("\(today.count)").font(.subheadline).foregroundColor(.tix)
                        }.padding(.leading).padding(.trailing)
                        
                        HStack(alignment: .top) {
                            Text(loc_overdue).font(.headline).foregroundColor(.tix)
                            Spacer()
                            Text("\(overdue.count)").font(.subheadline).foregroundColor(.tix)
                            
                        }.padding(.leading).padding(.trailing)
                        
                        HStack(alignment: .top) {
                            Text(loc_open_tasks).font(.headline).foregroundColor(.tix)
                            Spacer()
                            Text("\(open.count)").font(.subheadline).foregroundColor(.tix)
                        }.padding(.leading).padding(.trailing)
                        
                    }
                    .frame(maxWidth: .infinity, minHeight: 200, maxHeight: 200)
                    .background(Color.white)
                    .cornerRadius(10)
                }
                
                LazyVStack {
                    VStack(alignment: .leading) {
                        /*
                        HStack {
                            Spacer()
                            ForEach(categorySort, id: \.self) { day in
                                Text(day)
                                    .foregroundColor(Color(settings.globalBackground))
                                    .background(daySelection == day ? Color.tix : Color.white)
                                    .padding(daySelection == day ? 10 : 0)
                                Spacer()
                            }
                            
                        }
                        .padding(.top).padding(.bottom)
                        .background(Color.white)
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity)
                        */
                        
                        Picker(selection: $daySelection, label: Text("")) {
                            ForEach(categorySort, id: \.self) { day in
                                Text(day).foregroundColor(.tix)
                            }
                        }
                        .foregroundColor(.white)
                        .padding(.top)
                        .pickerStyle(SegmentedPickerStyle())
                        .labelsHidden()
                        .disabled(true)
                        
                        HStack {
                            Text(loc_your_todos)
                                .font(.title).bold()
                                .foregroundColor(Color.white)
                                .frame(alignment: .leading)
                            Spacer()
                            Picker(loc_choose_category, selection: $cat) {
                                ForEach(categories, id: \.self) { catt in
                                    HStack {
                                        Text(catt.name ?? "")
                                            .frame(alignment: .leading)
                                            .frame(maxWidth: .infinity)
                                            .foregroundColor(catt.color?.color ?? Color.white)
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
                            
                            
                            
                            HStack(alignment: .center) {
                                Image(systemName: todo.isDone ? "circle.fill" : "circle")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .onTapGesture {
                                        withAnimation {
                                            ViewContextMethods.isDone(todo: todo, context: viewContext)
                                        }
                                    }
                                    .foregroundColor(Color.tix.opacity(todo.isDone ? 0.5 : 1))
                                    .padding(.trailing, 10)
                                    .padding(.bottom)
                                    .padding(.top)
                                VStack(alignment: .leading){
                                    HStack {
                                        Text(todo.todo ?? "\(loc_todo)")
                                            .font(.headline)
                                            .foregroundColor(Color.tix.opacity(todo.isDone ? 0.5 : 1))
                                        
                                        Spacer()
                                        Image(systemName: todo.important ? "exclamationmark.circle" : "")
                                            .font(.headline)
                                            .foregroundColor(Color.red.opacity(todo.isDone ? 0.5 : 1))
                                    }
                                    HStack {
                                        Text(todo.hasDueDate ? "\(todo.dueDate!, formatter: itemFormatter)" : "")
                                            .font(.subheadline)
                                            .foregroundColor(Color.tix.opacity(todo.isDone ? 0.5 : 1))
                                        Spacer()
                                        Text(todo.todoCategory?.name ?? "")
                                            .font(.subheadline)
                                            .foregroundColor(Color.tix.opacity(todo.isDone ? 0.5 : 1))
                                    }
                                }
                                
                                
                            }
                            .padding(.leading).padding(.trailing)
                            .background(Color.white)
                            .cornerRadius(10)
                            .frame(maxWidth: .infinity)
                            
                        }
                    }
                }
            }
        }
        .accentColor(.white)
        .padding(.leading).padding(.trailing)
        .background(Color(settings.globalBackground))
        .onAppear(perform: onAppear)
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
        
        
        let today = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: today)
        let dayOfMonth = components.day
        let mComponents = calendar.dateComponents([.month], from: today)
        let month = mComponents.month
        
        let yDate = Date.now.addingTimeInterval(-86400)
        let yComponents = calendar.dateComponents([.day], from: yDate)
        let yesterday = yComponents.day
        
        let yyDate = Date.now.addingTimeInterval(-172800)
        let yyComponents = calendar.dateComponents([.day], from: yyDate)
        let yyesterday = yyComponents.day
        
        let tDate = Date.now.addingTimeInterval(86400)
        let tComponents = calendar.dateComponents([.day], from: tDate)
        let tomorrow = tComponents.day
        
        let ttDate = Date.now.addingTimeInterval(172800)
        let ttComponents = calendar.dateComponents([.day], from: ttDate)
        let ttomorrow = ttComponents.day
        
        categorySort = ["\(yyesterday!).\(month!)","\(yesterday!).\(month!)", "\(dayOfMonth!).\(month!)", "\(tomorrow!).\(month!)", "\(ttomorrow!).\(month!)"]
        daySelection = "\(dayOfMonth!).\(month!)"

        var one = ""
        var oneTicked = false
        var two = ""
        var twoTicked = false
        var three = ""
        var threeTicked = false
        var count = 0
        
        let tdReq = NSFetchRequest<Todo>(entityName: "Todo")
        let setSortDescriptor1 = NSSortDescriptor(keyPath: \Todo.todo, ascending: true)
        tdReq.fetchLimit = 3
        tdReq.sortDescriptors = [setSortDescriptor1]
        do {
            let sets = try self.viewContext.fetch(tdReq) as [Todo]
            var i = 0
            for cat in sets {
                if i == 0 {
                    one = cat.todo ?? "todo"
                    oneTicked = cat.isDone
                }
                if i == 1 {
                    two = cat.todo ?? "todo"
                    twoTicked = cat.isDone
                }
                if i == 2 {
                    three = cat.todo ?? "todo"
                    threeTicked = cat.isDone
                }
                i+=1
            }
            count = items.count
        } catch let error {
            NSLog("error in FetchRequest trying to get the first three todos for Widget: \(error.localizedDescription)")
        }
        WidgetUpdater(one: one, two: two, three: three, oneTicked: oneTicked, twoTicked: twoTicked, threeTicked: threeTicked, open: count).updateValues()
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

