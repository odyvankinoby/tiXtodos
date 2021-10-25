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
    @State var editItem = false
    
    @State private var searchQuery: String = ""
    @State private var notDoneOnly = false
    @State private var deleteTicked = false
    
    @State var edittext = ""
    
    var body: some View {
        VStack {
            HStack {
                
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
                
            }
            
            List {
                ForEach(todos, id: \.self) { todo in
                    
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
                                    .padding(10)
                                
                                Text(todo.todo ?? "todo")
                                    .font(.callout)
                                    .foregroundColor(.tix)
                                Spacer()
                            }
                        }
                        .frame(maxWidth: .infinity)
                    
                }.onDelete(perform: deleteItems(offsets:))
                    .listStyle(PlainListStyle())
                
                
            }
        }
        .sheet(isPresented: $newItem) { NewItem() }
        .background(LinearGradient(gradient: Gradient(colors: [.tix, .green]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
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


