//
//  SettingsApp.swift
//  tiX
//
//  Created by Nicolas Ott on 13.11.21.
//

import SwiftUI
import CoreData

struct SettingsApp: View {
    
    // Observable Objects
    @Environment(\.managedObjectContext) var viewContext
    @ObservedObject var settings: UserSettings
    @State var inlineEdit = false
    @FocusState private var isFocused: Bool
    @State var deletedTodos = 0
    
    var body: some View {
        
        VStack(alignment: .leading)
        {
            HStack {
                Text(loc_app_settings)
                    .frame(alignment: .leading)
                    .foregroundColor(Color(settings.globalForeground))
                    .padding(10)
                Spacer()
            }
            .background(RoundedCorners(color: Color(settings.globalBackground), tl: 10, tr: 10, bl: 0, br: 0))
            
            Group {
            HStack {
                Text(loc_name)
                    .frame(alignment: .leading)
                    .foregroundColor(Color(settings.globalText))
                Spacer()
                if !inlineEdit {
                    Text(settings.userName)
                        .frame(alignment: .trailing)
                        .foregroundColor(.tixDark)
                        .onTapGesture {
                            withAnimation {
                                inlineEdit = true
                                isFocused = true
                            }
                        }
                } else {
                    Button(action: {
                        withAnimation {
                            inlineEdit = false
                            isFocused = false
                        }
                    }) {
                        Image(systemName: "checkmark.circle").resizable()
                            .frame(width: 24, height: 24, alignment: .top).foregroundColor(Color(settings.globalText))
                    }
                }
            }.padding(.leading).padding(.trailing)
            
            if inlineEdit {
                TextField("", text: $settings.userName)
                    .focused($isFocused)
                    .frame(alignment: .trailing)
                    .foregroundColor(Color.tixDark)
                    .padding(.leading).padding(.trailing)
            }
            
            Divider()
            
            Toggle(isOn: $settings.hideTicked) {
                Text(loc_hide_ticked)
                    .foregroundColor(Color(settings.globalText)).frame(alignment: .trailing)
            }.padding(.leading).padding(.trailing)
            
            Divider()
            
            HStack {
                Text(loc_delete_ticked)
                    .frame(alignment: .leading)
                    .foregroundColor(Color(settings.globalText))
                Spacer()
                Spacer()
                Button(action: {
                    withAnimation {
                        deleteTicked()
                    }
                }) {
                    HStack {
                        Image(systemName: "circle.slash.fill")
                        Text(loc_delete)
                    }
                }
                .foregroundColor(.white)
                .padding(10)
                .background(Color(settings.globalBackground))
                .cornerRadius(8)
            }.padding(.leading).padding(.trailing)
            
            if deletedTodos > 0 {
                HStack() {
                    Spacer()
                    Text("\(deletedTodos)")
                        .foregroundColor(Color(settings.globalText))
                    Text(loc_deleted)
                        .foregroundColor(Color(settings.globalText))
                    Spacer()
                }.padding(.leading).padding(.trailing)
            }
            }
            Group {
            Divider()
                Toggle(isOn: $settings.showWelcome) {
                    Text(loc_show_welcome)
                        .foregroundColor(Color(settings.globalText)).frame(alignment: .trailing)
                }.padding(.leading).padding(.trailing).disabled(!settings.purchased)
            
            Divider()
            HStack() {
                Toggle(isOn: $settings.showEvents) {
                    Text(loc_show_events)
                        .foregroundColor(Color(settings.globalText)).frame(alignment: .trailing)
                }
                .onTapGesture {
                    if settings.showEvents {
                        let dc = CalendarImporter()
                        dc.requestAccess()
                    }
                }
                .padding(.leading).padding(.trailing).padding(.bottom).disabled(!settings.purchased)
            }
            }
            /*
            Divider()
            HStack {
                Text(loc_delete_ticked)
                    .frame(alignment: .leading)
                    .foregroundColor(Color(settings.globalText))
                Spacer()
                Spacer()
                Button(action: {
                    withAnimation {
                        deleteTicked()
                    }
                }) {
                    HStack {
                        Image(systemName: "circle.slash.fill")
                        Text(loc_delete)
                    }
                }
                .foregroundColor(.white)
                .padding(10)
                .background(Color(settings.globalBackground))
                .cornerRadius(8)
            }.padding(.leading).padding(.trailing)
            */
            
        }
        .onDisappear(perform: {deletedTodos=0})
        .background(Color.white)
        .cornerRadius(10)
        .frame(maxWidth: .infinity)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(settings.globalBackground == "White" ? Color.tix : Color(settings.globalForeground), lineWidth: 1).padding(1)
        )
        
    }
    
    func deleteTicked() {
        deletedTodos = 0
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
