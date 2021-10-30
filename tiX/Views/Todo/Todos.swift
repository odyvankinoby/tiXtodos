//
//  tiX.swift
//  tiX
//
//  Created by Nicolas Ott on 05.10.21.
//

import SwiftUI
import CoreData

struct Todos: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject var settings: UserSettings
    
    @FetchRequest(entity: Todo.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Todo.dueDate, ascending: false)]) var todos: FetchedResults<Todo>
    
    @FetchRequest(entity: Category.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)]) var categories: FetchedResults<Category>
    
    @State private var newItem = false
    @State private var selectCategory = false
    @State private var showImportant = false
    @State private var searchQuery: String = ""
    @State private var deleteTicked = false
    @State private var categorySelected = false
    @State private var cat = Category()
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    if selectCategory {
                        List {
                            ForEach(categories, id: \.self) { catItem in
                                
                                VStack(alignment: .leading){
                                    HStack(alignment: .center){
                                        Image(systemName: "square.fill")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .onTapGesture {
                                                withAnimation {
                                                    cat = catItem
                                                    categorySelected = true
                                                    selectCategory.toggle()
                                                }
                                            }
                                            .foregroundColor(catItem.color?.color ?? Color.tix)
                                            .padding(.trailing, 10)
                                            .padding(.bottom, 10)
                                            .padding(.top, 10)
                                        
                                        Text(catItem.name ?? "\(loc_category)")
                                            .font(.callout)
                                            .foregroundColor(catItem.color?.color ?? Color.tix)
                                        Spacer()
                                    }.onTapGesture {
                                        withAnimation {
                                            cat = catItem
                                            categorySelected = true
                                            selectCategory.toggle()
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    
                    
                    
                    List {
                        ForEach(searchResults, id: \.self) { todo in
                            
                            
                            NavigationLink(destination: EditItem(todo: todo, cat: todo.todoCategory ?? Category()).environment(\.managedObjectContext, self.viewContext))
                            {
                                VStack(alignment: .leading){
                                    
                                    HStack(alignment: .center){
                                        
                                        Image(systemName: todo.isDone ? "circle.fill" : "circle")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .onTapGesture {
                                                withAnimation {
                                                    ViewContextMethods.isDone(todo: todo, context: viewContext)
                                                }
                                            }
                                            .foregroundColor(todo.todoCategory?.color?.color ?? Color.tix)
                                            .padding(.trailing, 10)
                                            .padding(.bottom, 10)
                                            .padding(.top, 10)
                                        VStack(alignment: .leading){
                                            Text(todo.todo ?? "\(loc_todo)")
                                                .font(.headline)
                                                .foregroundColor(todo.todoCategory?.color?.color ?? Color.tix)
                                            Text("\(todo.dueDate!, formatter: itemFormatter)").font(.subheadline)
                                                .foregroundColor(todo.todoCategory?.color?.color.opacity(0.5) ?? Color.tix.opacity(0.5))
                                            //Text("\(todo.dueDate, formatter: Utils.timeFormatter)")
                                                
                                        }
                                            Spacer()
                                        
                                        Image(systemName: todo.important ? "exclamationmark.circle" : "")
                                            //.resizable()
                                            //.frame(width: 20, height: 20)
                                            .foregroundColor(.red)
                                           
                                        
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                
                            }
                        }.onDelete(perform: deleteItems(offsets:))
                            .listStyle(PlainListStyle())
                        
                    }
                    //.searchable(text: $searchQuery)
                    .navigationBarTitle(selectCategory ? loc_categories : loc_todos, displayMode: .automatic).allowsTightening(true)
                    .toolbar {
                        ToolbarItemGroup(placement: .navigationBarLeading) {
                            
                            if selectCategory && categorySelected {
                                Button(action: {
                                    withAnimation {
                                        categorySelected = false
                                        selectCategory.toggle()
                                    }
                                }) {
                                    Text(loc_all)
                                        .foregroundColor(.tix)
                                }
                                .toggleStyle(.button)
                            } else {
                                Button(action: {
                                    withAnimation {
                                        selectCategory.toggle()
                                        
                                    }
                                }) {
                                    Image(systemName: categorySelected ? "folder.fill" : "folder")
                                        .resizable()
                                        .foregroundColor(categorySelected ? cat.color?.color : .tix)
                                }
                                .toggleStyle(.button)
                            }
                            Button(action: {
                                withAnimation {
                                    showImportant.toggle()
                                    
                                }
                            }) {
                                Image(systemName: showImportant ? "exclamationmark.circle.fill" : "exclamationmark.circle")
                                    .resizable()
                                    .foregroundColor(showImportant ? .red : .tix)
                            }
                            .toggleStyle(.button)
                            .padding(.leading, 10)
                          
                        }
                        ToolbarItemGroup(placement: .navigationBarTrailing) {
                            
                            Button(action: {
                                withAnimation {
                                    newItem.toggle()
                                    
                                }
                                
                            }) {
                                Image(systemName: "plus")
                                    .resizable()
                                    .foregroundColor(.tix)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            
                        }
                    }
                    .sheet(isPresented: $newItem) { NewItem(cat: Category()) }
                    
                    
                }
            }.onAppear(perform: onAppear)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor(.tix) // NAV
        
    }
    
    private func onAppear() {
        
        getInbox()
        
        let setRequest = NSFetchRequest<Todo>(entityName: "Todo")
        //let setPredicate = NSPredicate(format: "isDone == true")
        let setSortDescriptor1 = NSSortDescriptor(keyPath: \Todo.todo, ascending: true)
        setRequest.fetchLimit = 3
        //setRequest.predicate = setPredicate
        setRequest.sortDescriptors = [setSortDescriptor1]
        var cnt = 0
        var one = ""
        var two = ""
        var three = ""
      
        do {
            let sets = try self.viewContext.fetch(setRequest) as [Todo]
            
            for td in sets {
                cnt+=1
               
                if cnt == 1 {
                    one = td.todo ?? ""
                    
                }
                if cnt == 2 {
                    two = td.todo ?? ""
                }
                if cnt == 3 {
                    three = td.todo ?? ""
                }
               
            }
        } catch let error {
            NSLog("error in FetchRequest trying to get top 3 todos: \(error.localizedDescription)")
        }
       
        WidgetUpdater(one: one, two: two, three: three, oneTicked: false, twoTicked: true, threeTicked: false, open: todos.count).updateValues()
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { todos[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func textChanged(upper: Int, text: inout String) {
        if text.count > upper {
            text = String(text.prefix(upper))
        }
    }
    
    
    var searchResults: [Todo] {
        if categorySelected {
            // getting all items
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
            // getting only searched items
            switch settings.hideTicked { //we will need this for our toggle later
            case true:
                return todos.filter {
                    !$0.todo!.isEmpty && $0.isDone == false && $0.important == self.showImportant
                }
            default:
                return todos.filter {
                    !$0.todo!.isEmpty && $0.important == self.showImportant
                }
            }
        }
    }
    
    
    func getInbox() {
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
    
    
    
    
}
private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    //formatter.timeStyle = .short
    return formatter
}()


/**
 
 } else {
 // getting only searched items
 switch settings.hideTicked { //we will need this for our toggle later
 case true:
 return todos.filter {
 $0.todo!.lowercased().contains(searchQuery.lowercased()) && $0.isDone == false
 }
 default:
 return todos.filter {
 $0.todo!.lowercased().contains(searchQuery.lowercased())
 }
 }
 }
 */

