//
//  tiX.swift
//  tiX
//
//  Created by Nicolas Ott on 05.10.21.
//

import SwiftUI
import CoreData

struct Items: View {

    @Environment(\.managedObjectContext) private var viewContext
    // Observable Objects
    @ObservedObject var settings: UserSettings
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.dueDate, ascending: false)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @Namespace private var namespace
    
    @State var settingsOpen = false
    @State var newItemOpen = false
    
    @State private var searchQuery: String = ""
    @State private var notDoneOnly = false
    @State private var deleteTicked = false
    
    var body: some View {
        ZStack {
        NavigationView {
            List {
                Section {
                    ForEach(searchResults, id: \.self) { item in
                        
                        if !(item.isDone && settings.hideTicked) {
                        
                        HStack {
                            Image(systemName: item.isDone ? "circle.fill" : "circle")
                                .resizable()
                                .foregroundColor(Color.tix)
                                .frame(width: 30, height: 30)
                                .onTapGesture {
                                    withAnimation {
                                        ViewContextMethods.isDone(item: item, context: viewContext)
                                    }
                                }
                                .padding(.trailing, 10)
                                        
                            VStack {
                                HStack {
                                    Text("\(item.toDoText ?? "")")
                                        .fixedSize(horizontal: false, vertical: true)
                                        Spacer()
                                }
                                .padding(.bottom, 5)
                                            
                                HStack {
                                    Text("Due: \(item.dueDate!, formatter: itemFormatter)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text(item.category ?? "Unknown")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.leading, 5)
                        }
                        .frame(maxHeight: 130)
                        //.listRowSeparator(.hidden) // no separators
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                
            }
            .listStyle(SidebarListStyle()) //InsetGroupedListStyle()
            .refreshable {
                //await store.loadStats()
                print("refreshed")
            }
            
            .sheet(isPresented: $settingsOpen) {
               
                Settings(settings: settings)
                
            }
            .sheet(isPresented: $newItemOpen) {
               
                NewItem()
                
            }
          //.searchable(text: "Search in history", placement: $searchQuery)
            .navigationTitle("Todos")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
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
                                .foregroundColor(.tix)
                                //.shadow(color: .tix.opacity(0.3), radius: 10, x: 0, y: 10)
                                
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    HStack {
                        Button(action: {
                            withAnimation {
                                settingsOpen.toggle()
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
            // MARK: Bottom button to add new item
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    Button(action: {
                        withAnimation {
                            newItemOpen.toggle()
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
    }

  
    
    
    
private func deleteItems(offsets: IndexSet) {
    withAnimation {
        offsets.map { items[$0] }.forEach(viewContext.delete)

        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
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


var searchResults: [Item] {
if searchQuery.isEmpty{
    // getting all items
    switch notDoneOnly { //we will need this for our toggle later
    case true:
        return items.filter {
            !$0.toDoText!.isEmpty && $0.isDone == false
        }
    default:
        return items.filter {
            !$0.toDoText!.isEmpty
        }
    }
} else {
    // getting only searched items
    switch notDoneOnly { //we will need this for our toggle later
    case true:
        return items.filter {
            $0.toDoText!.lowercased().contains(searchQuery.lowercased()) && $0.isDone == false
        }
    default:
        return items.filter {
            $0.toDoText!.lowercased().contains(searchQuery.lowercased())
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

