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
                    //.shadow(color: .tix.opacity(0.3), radius: 10, x: 0, y: 10)
                    
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.leading, 10)
                
                Spacer()
                
                Text("Items").font(.title).foregroundColor(.white)
               
                Spacer()
                
                Button(action: {
                    withAnimation {
                        newItem.toggle()
                        //   Haptics.giveSmallHaptic()
                    }
                    Haptics.giveSmallHaptic()
                }) {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)
                    //.shadow(color: .tix.opacity(0.3), radius: 10, x: 0, y: 10)
                    
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.trailing, 10)
                
            }
            
            
            
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
                                
                                
                                NavigationLink(destination: EditItem(item: item)) {
                                    
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text("\(item.toDoText ?? "")")
                                                .fixedSize(horizontal: false, vertical: true)
                                        }
                                        Spacer()
                                        HStack {
                                            Text("Due: \(item.dueDate!, formatter: itemFormatter)")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                            Spacer()
                                        }
                                    }
                                    .padding(.leading, 5)
                                }
                            }
                            .frame(maxHeight: 130)
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                
            }
            .listStyle(InsetGroupedListStyle()) //InsetGroupedListStyle()
            .refreshable {
                //await store.loadStats()
                print("refreshed")
            }
            .sheet(isPresented: $newItem) {
                NewItem()
            }
            
        }.background(LinearGradient(gradient: Gradient(colors: [.tix, .green]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
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


