//
//  NewItem.swift
//  tiX
//
//  Created by Nicolas Ott on 05.10.21.
//


import SwiftUI
import Combine

struct NewItem: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @FetchRequest(entity: Category.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Category.category, ascending: true)]) var categories: FetchedResults<Category>
    
    @State private var selectedColor = "Red"
    var colors = ["Red", "Green", "Blue", "Tartan"]
    
    @State private var dueDate = Date()
    @State private var toDoText = ""
    @State var category: Category
    
    let toDoTextLimit = 70
    
    var body: some View {
        NavigationView {
            VStack {
               
                DatePicker(selection: $dueDate, displayedComponents: .date) {
                    Text("Due date")
                    
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .accentColor(Color.indigo)
                .padding()
                
                
                if toDoText.isEmpty {
                    
                    Text("Enter your todo item")
                        .font(Font.body)
                        .foregroundColor(Color.gray)
                    Spacer()
                    
                }
                TextEditor(text: $toDoText)
                
                    .frame(height: 200, alignment: .leading)
                    .frame(maxWidth: .infinity)
                    .lineSpacing(5)
                    .onReceive(Just(toDoText)) { toDoText in
                        textChanged(upper: toDoTextLimit, text: &self.toDoText)
                    }
                    .zIndex(1)
                    .opacity(toDoText.isEmpty ? 0.25 : 1)
                
                
                Text("Category")
                    .frame(alignment: .leading)
                    .frame(maxWidth: .infinity)
                    .padding().background(Color.tix.opacity(0.5))
                HStack {
                    Picker("Please choose a Category", selection: $category) {
                                    ForEach(categories, id: \.self) { cat in
                                        Text(cat.category ?? "-none-")
                                            .frame(alignment: .leading)
                                            .frame(maxWidth: .infinity)
                                            .foregroundColor(Color.tix)
                                    }
                                }
                   
                }.padding()
               
            }.toolbar {
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
         }.navigationBarTitle("New Todos", displayMode: .automatic).allowsTightening(true)
    }
    
    func textChanged(upper: Int, text: inout String) {
        if text.count > upper {
            text = String(text.prefix(upper))
        }
    }
    
    
    func saveAction() {
        let newTodo = Todo(context: self.viewContext)
        newTodo.todo = self.toDoText
        newTodo.category = self.category
        newTodo.dueDate = self.dueDate
        newTodo.id = UUID()
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
