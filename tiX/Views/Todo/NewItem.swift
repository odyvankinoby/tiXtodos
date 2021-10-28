//
//  NewItem.swift
//  tiX
//
//  Created by Nicolas Ott on 05.10.21.
//


import SwiftUI
import CoreData

struct NewItem: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @FetchRequest(entity: Category.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)]) var categories: FetchedResults<Category>

    @State private var selectedColor = "Red"
    var colors = ["Red", "Green", "Blue", "Tartan"]
    
    @State private var dueDate = Date()
    @State private var toDoText = ""
    @State private var important = false
    
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
                                        Text(catt.name ?? "-none-")
                                            .frame(alignment: .leading)
                                            .frame(maxWidth: .infinity)
                                            .foregroundColor(catt.color?.color ?? Color.tix)
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
                
                Text("Important")
                    .frame(alignment: .leading)
                    .frame(maxWidth: .infinity)
                    .padding().background(Color.tix.opacity(0.5))
                Toggle(isOn: self.$important) {
                        Text("Important")
                            .foregroundColor(.tix).frame(alignment: .trailing)
                }
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
    
    func onAppear() {
        
        let setRequest = NSFetchRequest<Category>(entityName: "Category")
        let setPredicate = NSPredicate(format: "isDefault == true")
        let setSortDescriptor1 = NSSortDescriptor(keyPath: \Category.name, ascending: true)
        setRequest.fetchLimit = 1
        setRequest.predicate = setPredicate
        setRequest.sortDescriptors = [setSortDescriptor1]
        
        do {
            let sets = try self.viewContext.fetch(setRequest) as [Category]
            for cat in sets {
                self.cat = cat
            }
        } catch let error {
            NSLog("error in FetchRequest trying to get default category: \(error)")
        }
        
    }
    func saveAction() {
        let newTodo = Todo(context: self.viewContext)
        newTodo.todo = self.toDoText
        newTodo.todoCategory = self.cat
        newTodo.dueDate = self.dueDate
        newTodo.timestamp = Date()
        newTodo.important = self.important
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
