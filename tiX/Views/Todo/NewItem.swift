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
    @State var cat: Category
    @State var col = Color.tix
    
    let toDoTextLimit = 70
    
    var body: some View {
        NavigationView {
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
                    Image(systemName: "square.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(self.col)
                        .padding(.trailing, 10)
                        .padding(.bottom, 10)
                        .padding(.top, 10)
                    Picker("Please choose a Category", selection: $cat) {
                                    ForEach(categories, id: \.self) { catt in
                                        Text(catt.category ?? "-none-")
                                            .frame(alignment: .leading)
                                            .frame(maxWidth: .infinity)
                                    }
                                }.onChange(of: cat, perform: { (value) in
                                    pickerChanged()
                                })
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
            }.toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button(action: {
                        withAnimation {
                            cancelAction()
                            Haptics.giveSmallHaptic()
                        }
                    }) {
                        Text("Discard")
                            .foregroundColor(.tix)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                }
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
    
    func pickerChanged() {
        col = cat.color?.color ?? Color.tix
    }
    
    func saveAction() {
        let newTodo = Todo(context: self.viewContext)
        newTodo.todo = self.toDoText
        newTodo.category = self.cat
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
