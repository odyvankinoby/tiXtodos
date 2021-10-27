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
    @FetchRequest(entity: Category.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Category.category, ascending: true)]) var categories: FetchedResults<Category>
    
    @State private var newItem = false
    @State private var searchQuery: String = ""
    @State private var deleteTicked = false
    @State var cat: Category
    
    var body: some View {
        NavigationView {
            VStack {
                
                HStack {
                    
                    
                    List {
                        ForEach(searchResults, id: \.self) { todo in
                            
                            
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
                                            .foregroundColor(todo.category?.color?.color ?? Color.tix)
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
                        }.onDelete(perform: deleteItems(offsets:))
                            .listStyle(PlainListStyle())
                        
                    }
                    .searchable(text: $searchQuery)
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
                    .sheet(isPresented: $newItem) { NewItem(cat: Category()) }
                    
                    Picker("Please choose a Category", selection: $cat) {
                                    ForEach(categories, id: \.self) { catt in
                                        Text(catt.category ?? "-none-")
                                            .frame(alignment: .leading)
                                            .frame(maxWidth: .infinity)
                                    }
                                }.onChange(of: cat, perform: { (value) in
                                    //
                                })
                }
            }
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
    }
}
private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()


