//
//  Today.swift
//  tiX
//
//  Created by Nicolas Ott on 30.10.21.
//

import SwiftUI
import CoreData

struct Todos: View {
    
    @Environment(\.managedObjectContext) var viewContext
    @ObservedObject var settings: UserSettings
    @State var dc: DefaultCategory
    @Binding var tabSelected: Int
    
    @FetchRequest(entity: Todo.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Todo.timestamp, ascending: false)]) var todos: FetchedResults<Todo>
    
    @FetchRequest(entity: Todo.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Todo.todo, ascending: false)], predicate: NSPredicate(format: "dueDate >= %@", Date().midnight as CVarArg)) var today: FetchedResults<Todo>
    
    @FetchRequest(entity: Todo.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Todo.todo, ascending: false)], predicate: NSPredicate(format: "dueDate < %@", Date().midnight as CVarArg)) var overdue: FetchedResults<Todo>
    
    @FetchRequest(entity: Category.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)]) var categories: FetchedResults<Category>
    
    
        
    @State private var selectCategory = false
    
    @State private var showImportant = false
    
    @State private var showOverdue = false
    
    @State private var showToday = false
    
    @State private var showAll = true
    
    @State private var deleteTicked = false
    
    @State private var categorySelected = false
    
    @State private var cat = Category()
    
    // Inline Edit
    @State private var inlineEdit = false
    @State private var inlineItem = UUID()
    @State private var inlineTodo = ""
    @State private var editInProgress = 0
    
    @State private var accentColor = Color.tix
    
    private var todaysItems: [Todo] {
        today.filter {
            Calendar.current.isDate($0.dueDate ?? Date(), equalTo: Date(), toGranularity: .day)
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    withAnimation {
                        showAll = true
                        showOverdue = false
                        showToday = false
                        categorySelected = false
                        showImportant = false
                        selectCategory = false
                    }
                }) {
                    Image(systemName: showAll ? "list.bullet.circle.fill" : "list.bullet.circle")
                        .foregroundColor(Color(settings.globalForeground))
                        .font(.title)
                        .padding(.top)
                }.disabled(inlineEdit)
                
                Button(action: {
                    withAnimation {
                        showAll = false
                        showOverdue = false
                        showToday = true
                    }
                }) {
                    Image(systemName: showToday ? "calendar.circle.fill" : "calendar.circle")
                        .foregroundColor(Color(settings.globalForeground))
                        .font(.title)
                        .padding(.top)
                }.disabled(inlineEdit)
                
                Button(action: {
                    withAnimation {
                        showAll = false
                        showOverdue = true
                        showToday = false
                    }
                }) {
                    Image(systemName: showOverdue ? "clock.badge.exclamationmark.fill" : "clock.badge.exclamationmark")
                        .foregroundColor(Color(settings.globalForeground))
                        .font(.title)
                        .padding(.top)
                }.disabled(inlineEdit)
                
                Button(action: {
                    withAnimation {
                        showImportant.toggle()
                    }
                }) {
                    Image(systemName: showImportant ? "exclamationmark.circle.fill" : "exclamationmark.circle")
                        .foregroundColor(Color(settings.globalForeground))
                        .font(.title)
                        .padding(.top)
                }.disabled(inlineEdit)

                Spacer()

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

            }
            
            HStack {
                Text(showToday ? loc_today : showOverdue ? loc_overdue : loc_all_todos)
                    .font(.title).bold()
                    .foregroundColor(Color(settings.globalForeground))
                    .frame(alignment: .leading)
                    .padding(.top, 5)
                Spacer()
                if categorySelected {
                    HStack {
                        Picker(loc_choose_category, selection: $cat) {
                            ForEach(categories, id: \.self) { catt in
                                Text("\(catt.name ?? "") (\(catt.todo?.count ?? 0))")
                            }
                        }
                        .onAppear(perform: {
                            self.accentColor = cat.color?.color ?? Color.tix
                        })
                        .onChange(of: cat, perform: { (value) in
                            cat = value
                            categorySelected = true
                            self.accentColor = cat.color?.color ?? Color.tix
                        })
                        .frame(alignment: .trailing)
                        .disabled(inlineEdit)
                        Button(action: {
                            withAnimation {
                                categorySelected.toggle()
                            }
                        }) {
                            Image(systemName: "xmark.circle")
                                .foregroundColor(cat.color?.color ?? Color.tix)
                                .font(.body)
                        }
                        .toggleStyle(.button)
                        .disabled(inlineEdit)
                    }.padding(.leading)
                    .padding(.trailing)
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(settings.globalBackground == "White" ? Color.tix : Color(settings.globalForeground), lineWidth: 1)
                        )
                    
                } else {
                    
                    HStack {
                        Text(loc_categories)
                            .foregroundColor(Color(settings.globalForeground))
                            .font(.body)
                        Image(systemName: "chevron.down.circle")
                            .foregroundColor(Color(settings.globalForeground))
                            .font(.body)
                    }.onTapGesture {
                        withAnimation {
                            categorySelected = true
                        }
                    }
                    .padding(.leading)
                    .padding(.trailing)
                    .padding(.top, 5).padding(.bottom, 5)
                    .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(settings.globalBackground == "White" ? Color.tix : Color(settings.globalForeground), lineWidth: 1)
                        )
                     
                }
            }.padding(.top)
            
            ZStack {
            
            ScrollView {
                
                ForEach(showToday ? todayResults : showOverdue ? overdueResults : todosFiltered, id: \.self) { todo in
                    
                    // Inline Edit
                    if inlineEdit && todo.id == inlineItem {
                        
                        TodoEdit(settings: settings,
                                 todo: todo,
                                 inlineEdit: $inlineEdit,
                                 inlineItem: $inlineItem,
                                 inlineTodo: todo.todo ?? "",
                                 inlineText: todo.text ?? "",
                                 cat: todo.todoCategory ?? self.cat,
                                 hasDD: todo.hasDueDate,
                                 dd: todo.dueDate ?? Date(),
                                 prio: todo.important,
                                 accentColor: $accentColor).environment(\.managedObjectContext, viewContext)
                            .onDisappear(perform: {
                                WidgetUpdater().getSetValues(viewContext: viewContext)
                            })
                        
                    } else {
                        HStack(alignment: .center){
                            Image(systemName: todo.isDone ? "circle.fill" : "circle")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .onTapGesture {
                                    withAnimation {
                                        ViewContextMethods.isDone(todo: todo, context: viewContext)
                                    }
                                }
                                .foregroundColor(todo.todoCategory?.color?.color.opacity(todo.isDone ? 0.5 : 1) ?? Color.tix.opacity(todo.isDone ? 0.5 : 1))
                                .padding(.trailing, 10)
                                .padding(.bottom)
                                .padding(.top)
                            VStack(alignment: .leading){
                                HStack(alignment: .top) {
                                    Text(todo.todo ?? "\(loc_todo)")
                                        .onTapGesture {
                                            withAnimation {
                                                if !inlineEdit {
                                                    inlineEdit = true
                                                    inlineItem = todo.id ?? UUID()
                                                    //isFocused = true
                                                    inlineTodo = todo.todo ?? ""
                                                    accentColor = todo.todoCategory?.color?.color ?? Color.tix
                                                }
                                            }
                                        }
                                        .font(.headline)
                                        .foregroundColor(todo.todoCategory?.color?.color.opacity(todo.isDone ? 0.5 : 1) ?? Color.tix.opacity(todo.isDone ? 0.5 : 1))
                                    Spacer()
                                    if todo.important {
                                        Image(systemName: "exclamationmark.circle")
                                            .foregroundColor(Color.red.opacity(todo.isDone ? 0.5 : 1))
                                    }
                                }
                                HStack(alignment: .bottom) {
                                    Text(todo.hasDueDate ? "\(todo.dueDate!, formatter: itemFormatter)" : "")
                                        .font(.subheadline)
                                        .foregroundColor(todo.todoCategory?.color?.color.opacity(todo.isDone ? 0.5 : 1) ?? Color.tix.opacity(todo.isDone ? 0.5 : 1))
                                    Spacer()
                                    Text(todo.todoCategory?.name ?? "").font(.subheadline)
                                        .foregroundColor(todo.todoCategory?.color?.color.opacity(todo.isDone ? 0.5 : 1) ?? Color.tix.opacity(todo.isDone ? 0.5 : 1))
                                }
                            }
                        }
                        .padding(.leading)
                        .padding(.trailing)
                        .padding(.top, 5).padding(.bottom, 5)
                        .background(Color.white)
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity)
                        .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(settings.globalBackground == "White" ? Color.tix : Color(settings.globalForeground), lineWidth: 1).padding(1)
                            )
                        
                    }
                }
            }
            VStack(alignment: .trailing) {
                Spacer()
                Spacer()
                Spacer()
                HStack {
                    Spacer()
                    Spacer()
                    Button(action: {
                        withAnimation {
                            newTodo(cat: self.cat)
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(Color(settings.globalForeground))
                            .shadow(color: Color(settings.globalBackground).opacity(0.5), radius: 10, x: 0, y: 0)
                    }.padding(.bottom,30)
                }
            }
            .padding(.bottom)
            .frame(maxWidth: .infinity)
            
            }
        }
        .accentColor(self.accentColor)
        .padding(.leading).padding(.trailing)
        .background(Color(settings.globalBackground))
        .onAppear(perform: onAppear)
        .onDisappear(perform: onDisappear)
    }
    
    private func onDisappear() {
        inlineEdit = false
        inlineItem = UUID()
        WidgetUpdater().getSetValues(viewContext: viewContext)
    }
    
    private func onAppear() {
        
        self.cat = dc.defaultCategory
        WidgetUpdater().getSetValues(viewContext: viewContext)
        self.accentColor = Color(settings.globalText)
        
    }
    
    private func endInlineEdit() {
        inlineEdit = false
        inlineItem = UUID()
        WidgetUpdater().getSetValues(viewContext: viewContext)
    }
    
    var todosFiltered: [Todo] {
        
        if categorySelected {
            if showImportant {
                switch settings.hideTicked { //we will need this for our toggle later
                case true:
                    return todos.filter {
                        !$0.todo!.isEmpty && $0.isDone == false && $0.todoCategory == cat && $0.important == true
                    }
                default:
                    return todos.filter {
                        !$0.todo!.isEmpty && $0.todoCategory == cat && $0.important == true
                    }
                }
            } else {
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
            }
        } else {
            if showImportant {
                switch settings.hideTicked { //we will need this for our toggle later
                case true:
                    return todos.filter {
                        !$0.todo!.isEmpty && $0.isDone == false && $0.important == true
                    }
                default:
                    return todos.filter {
                        !$0.todo!.isEmpty && $0.important == true
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
    
    
    var allResults: [Todo] {
        if categorySelected {
            if showImportant {
                switch settings.hideTicked { //we will need this for our toggle later
                case true:
                    return today.filter {
                        !$0.todo!.isEmpty && $0.isDone == false && $0.todoCategory == cat && $0.important == true
                    }
                default:
                    return today.filter {
                        !$0.todo!.isEmpty && $0.todoCategory == cat && $0.important == true
                    }
                }
            } else {
                switch settings.hideTicked { //we will need this for our toggle later
                case true:
                    return today.filter {
                        !$0.todo!.isEmpty && $0.isDone == false && $0.todoCategory == cat
                    }
                default:
                    return today.filter {
                        !$0.todo!.isEmpty && $0.todoCategory == cat
                    }
                }
            }
        } else {
            if showImportant {
                switch settings.hideTicked { //we will need this for our toggle later
                case true:
                    return today.filter {
                        !$0.todo!.isEmpty && $0.isDone == false && $0.important == true
                    }
                default:
                    return today.filter {
                        !$0.todo!.isEmpty && $0.important == true
                    }
                }
            }
            else {
                switch settings.hideTicked { //we will need this for our toggle later
                case true:
                    return today.filter {
                        !$0.todo!.isEmpty && $0.isDone == false
                    }
                default:
                    return today.filter {
                        !$0.todo!.isEmpty
                    }
                }
            }
        }
    }
    
    var todayResults: [Todo] {
        if categorySelected {
            if showImportant {
                switch settings.hideTicked { //we will need this for our toggle later
                case true:
                    return today.filter {
                        !$0.todo!.isEmpty && $0.isDone == false && $0.todoCategory == cat && $0.important == true
                    }
                default:
                    return today.filter {
                        !$0.todo!.isEmpty && $0.todoCategory == cat && $0.important == true
                    }
                }
            } else {
                switch settings.hideTicked { //we will need this for our toggle later
                case true:
                    return today.filter {
                        !$0.todo!.isEmpty && $0.isDone == false && $0.todoCategory == cat
                    }
                default:
                    return today.filter {
                        !$0.todo!.isEmpty && $0.todoCategory == cat
                    }
                }
            }
        } else {
            if showImportant {
                switch settings.hideTicked { //we will need this for our toggle later
                case true:
                    return today.filter {
                        !$0.todo!.isEmpty && $0.isDone == false && $0.important == true
                    }
                default:
                    return today.filter {
                        !$0.todo!.isEmpty && $0.important == true
                    }
                }
            }
            else {
                switch settings.hideTicked { //we will need this for our toggle later
                case true:
                    return today.filter {
                        !$0.todo!.isEmpty && $0.isDone == false
                    }
                default:
                    return today.filter {
                        !$0.todo!.isEmpty
                    }
                }
            }
        }
    }
    
    var overdueResults: [Todo] {
        if categorySelected {
            if showImportant {
                switch settings.hideTicked { //we will need this for our toggle later
                case true:
                    return overdue.filter {
                        !$0.todo!.isEmpty && $0.isDone == false && $0.todoCategory == cat && $0.important == true
                    }
                default:
                    return overdue.filter {
                        !$0.todo!.isEmpty && $0.todoCategory == cat && $0.important == true
                    }
                }
            } else {
                switch settings.hideTicked { //we will need this for our toggle later
                case true:
                    return overdue.filter {
                        !$0.todo!.isEmpty && $0.isDone == false && $0.todoCategory == cat
                    }
                default:
                    return overdue.filter {
                        !$0.todo!.isEmpty && $0.todoCategory == cat
                    }
                }
            }
        } else {
            if showImportant {
                switch settings.hideTicked { //we will need this for our toggle later
                case true:
                    return overdue.filter {
                        !$0.todo!.isEmpty && $0.isDone == false && $0.important == true
                    }
                default:
                    return overdue.filter {
                        !$0.todo!.isEmpty && $0.important == true
                    }
                }
            }
            else {
                switch settings.hideTicked { //we will need this for our toggle later
                case true:
                    return overdue.filter {
                        !$0.todo!.isEmpty && $0.isDone == false
                    }
                default:
                    return overdue.filter {
                        !$0.todo!.isEmpty
                    }
                }
            }
        }
    }
    
    func newTodo(cat: Category) {
        let newTodo = Todo(context: self.viewContext)
        newTodo.todo = "Todo"
        newTodo.text = ""
        newTodo.todoCategory = cat
        newTodo.hasDueDate = false
        newTodo.dueDate = nil
        newTodo.timestamp = Date()
        newTodo.important = false
        newTodo.id = UUID()
        do {
            try self.viewContext.save()
            inlineEdit = true
            inlineItem = newTodo.id ?? UUID()
            inlineTodo = newTodo.todo ?? ""
        } catch {
            NSLog(error.localizedDescription)
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    //formatter.timeStyle = .short
    return formatter
}()
