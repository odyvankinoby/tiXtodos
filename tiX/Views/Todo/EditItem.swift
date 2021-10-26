//
//  EditItem.swift
//  tiX
//
//  Created by Nicolas Ott on 12.10.21.
//

import SwiftUI
import Combine

struct EditItem: View {
    
    @State var todo: Todo
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @FetchRequest(entity: Category.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Category.category, ascending: true)]) var categories: FetchedResults<Category>
    
    @State  var dueDate = Date()
    @State  var toDoText = ""
    @State  var cat: Category
    @State private var selectedColor = "Red"
    var colors = ["Red", "Green", "Blue", "Tartan"]
                    
    let toDoTextLimit = 70
    
    var body: some View {
        
        VStack {
            ScrollView() {
                Text("Todo")
                    .frame(alignment: .leading)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.tix.opacity(0.5))
                TextField("", text: $toDoText)
                    .frame(alignment: .leading)
                    .frame(maxWidth: .infinity)
                    .onReceive(Just(toDoText)) { toDoText in
                        textChanged(upper: toDoTextLimit, text: &self.toDoText)
                    }
                    .opacity(toDoText.isEmpty ? 0.25 : 1)
                    .foregroundColor(Color.tix)
                    .padding()
                
                Text("Category")
                    .frame(alignment: .leading)
                    .frame(maxWidth: .infinity)
                    .padding().background(Color.tix.opacity(0.5))
                HStack {
                    Picker("Please choose a Category", selection: $cat) {
                                    ForEach(categories, id: \.self) { cat in
                                        Text(cat.category ?? "-none-")
                                            .frame(alignment: .leading)
                                            .frame(maxWidth: .infinity)
                                            .foregroundColor(Color.tix)
                                    }
                                }
                   
                }.padding()
               
              
                
                Text("Due date")
                    .frame(alignment: .leading)
                    .frame(maxWidth: .infinity)
                    .padding().background(Color.tix.opacity(0.5))
                DatePicker(selection: $dueDate, displayedComponents: .date) {
                    Text("Due date")
                    
                }.foregroundColor(Color.tix)
                .padding()
                .accentColor(Color.tix)

            }
            .frame(maxWidth: .infinity)
            .background(Color(UIColor.systemBackground))
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.tix.opacity(0.5), lineWidth: 0.5))
            .padding()
      
        .onAppear(perform: onAppear)
     
        .navigationBarTitle(self.toDoText, displayMode: .automatic).allowsTightening(true)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {
                    withAnimation {
                        saveAction()
                        Haptics.giveSmallHaptic()
                    }
                }) {
                    Text("Save")
                        .foregroundColor(.tix)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
            
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor(.tix) // NAV
    }
    
    func onAppear() {
        toDoText = todo.todo ?? ""
        dueDate = todo.dueDate ?? Date()
        cat = todo.category ?? Category()
    }
    
    func textChanged(upper: Int, text: inout String) {
        if text.count > upper {
            text = String(text.prefix(upper))
        }
    }
    
    func saveAction() {
        todo.todo = self.toDoText
        todo.dueDate = self.dueDate
        todo.category = self.cat
            do {
                try self.viewContext.save()
            } catch {
                NSLog(error.localizedDescription)
            }
        self.cancelAction()
    }
    
    func cancelAction() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
}
