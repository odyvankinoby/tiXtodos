//
//  Settings.swift
//  tiX
//
//  Created by Nicolas Ott on 09.10.21.
//

import SwiftUI
import CoreData

struct Settings: View {
    
    // Observable Objects
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var settings: UserSettings
    @State var deletedTodos = 0
    var body: some View {
        
        NavigationView {
            
            ScrollView() {
                
                Text("Settings")
                    .frame(alignment: .leading)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.tix.opacity(0.5))
                
                Toggle(isOn: $settings.hideTicked) {
                    Text("Hide ticked Todos")
                        .foregroundColor(.tix).frame(alignment: .trailing)
                }.padding(.leading, 10).padding(.trailing, 10)
                
                Divider()
                
                HStack {
                    Text("Delete ticked Todos")
                        .frame(alignment: .leading)
                        .padding(.leading, 10)
                        .foregroundColor(.tix)
                    Spacer()
                    Button(action: {
                        withAnimation {
                            deleteTicked()
                        }
                    }) {
                        Image(systemName: "delete.backward")
                        
                            .foregroundColor(.tix).frame(alignment: .trailing)
                    }.padding(.trailing, 10)
                   
                }
                
            }
            .frame(maxWidth: .infinity)
            .background(Color(UIColor.systemBackground))
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.tix.opacity(0.5), lineWidth: 0.5))
            .padding()
            .navigationBarTitle("Settings", displayMode: .automatic).allowsTightening(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor(.tix) // NAV
    }
    
    
    
    func deleteTicked() {
        let setRequest = NSFetchRequest<Todo>(entityName: "Todo")
        let setPredicate = NSPredicate(format: "isDone == true")
        let setSortDescriptor1 = NSSortDescriptor(keyPath: \Todo.todo, ascending: true)
        setRequest.predicate = setPredicate
        setRequest.sortDescriptors = [setSortDescriptor1]
        do {
            let sets = try self.viewContext.fetch(setRequest) as [Todo]
            
            for cat in sets {
                viewContext.delete(cat)
                do {
                    try viewContext.save()
                    deletedTodos+=1
                } catch {
                    NSLog("error deleting todo: \(error.localizedDescription)")
                }
                
            }
        } catch let error {
            NSLog("error in FetchRequest trying to get default category: \(error.localizedDescription)")
        }
    }
}


