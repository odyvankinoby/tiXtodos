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

    @State var newItem = false
    @State var newCategory = false
  
    @State private var searchQuery: String = ""
    @State private var notDoneOnly = false
    @State private var deleteTicked = false
  
    var body: some View {
        NavigationView {
            
            /*HStack {
                
                Button(action: {
                    withAnimation {
                        settings.hideTicked.toggle()
                        //   Haptics.giveSmallHaptic()
                    }
                    Haptics.giveSmallHaptic()
                }) {
                    Image(systemName: settings.hideTicked ? "list.bullet.circle" : "list.bullet.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)
                   
                    
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.leading, 10)
                Spacer()
                
                Text("Todos").font(.title).foregroundColor(.white)
                Spacer()
                
                Button(action: {
                    withAnimation {
                        newItem.toggle()
                        Haptics.giveSmallHaptic()
                    }
                    Haptics.giveSmallHaptic()
                }) {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.trailing, 10)
                
            }*/
            
            List {
                ForEach(todos, id: \.self) { todo in
                    
                    if !(settings.hideTicked && todo.isDone) {
                        NavigationLink(destination: EditItem(todo: todo, cat: todo.category ?? Category(), col: todo.category?.color?.color ?? Color.tix).environment(\.managedObjectContext, self.viewContext))
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
                                    .foregroundColor(.tix)
                                    .padding(.trailing, 10)
                                    .padding(.bottom, 10)
                                    .padding(.top, 10)
                                
                                Text(todo.todo ?? "todo")
                                    .font(.callout)
                                    .foregroundColor(.tix)
                                Spacer()
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    }
                }.onDelete(perform: deleteItems(offsets:))
                    .listStyle(PlainListStyle())
               
            }
            .navigationBarTitle("Todos", displayMode: .automatic).allowsTightening(true)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button(action: {
                        withAnimation {
                            settings.hideTicked.toggle()
                            Haptics.giveSmallHaptic()
                        }
                        Haptics.giveSmallHaptic()
                    }) {
                        Image(systemName: settings.hideTicked ? "circle" : "circle.fill")
                            .resizable()
                            .foregroundColor(.tix)
                    }
                    .buttonStyle(PlainButtonStyle())
                   
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                      
                    Button(action: {
                        withAnimation {
                            newCategory.toggle()
                            Haptics.giveSmallHaptic()
                        }
                        Haptics.giveSmallHaptic()
                    }) {
                        Image(systemName: "plus.square.on.square")
                            .resizable()
                            .foregroundColor(.tix)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button(action: {
                        withAnimation {
                            newItem.toggle()
                            Haptics.giveSmallHaptic()
                        }
                        Haptics.giveSmallHaptic()
                    }) {
                        Image(systemName: "plus")
                            .resizable()
                            .foregroundColor(.tix)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    
                }
            }
            .sheet(isPresented: $newItem) { NewItem(category: Category()) }
            .sheet(isPresented: $newCategory) { NewCategory() }

        }
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor(.tix) // NAV
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
        if searchQuery.isEmpty{
            // getting all items
            switch notDoneOnly { //we will need this for our toggle later
            case true:
                return todos.filter {
                    !$0.todo!.isEmpty && $0.isDone == false
                }
            default:
                return todos.filter {
                    !$0.todo!.isEmpty
                }
            }
        } else {
            // getting only searched items
            switch notDoneOnly { //we will need this for our toggle later
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
    }
}
private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()


