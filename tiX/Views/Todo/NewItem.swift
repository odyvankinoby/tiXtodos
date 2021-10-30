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

    @State private var dueDate = Date()
    @State private var toDoText: LocalizedStringKey = loc_new_todo
    @State private var todo = ""
    @State private var important = false
    @FocusState private var isFocused: Bool
    
    @State var cat: Category
    @State var col = Color.tix
    
    let toDoTextLimit = 70
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                /*
                Text("")
                    .frame(alignment: .leading)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(self.col)
                */
                TextField(loc_todo, text: $todo)
                    .frame(alignment: .leading)
                    .frame(maxWidth: .infinity)
                    .opacity(todo == "\(loc_new_todo)" ? 0.5 : 1)
                    .foregroundColor(Color.tix)
                    .focused($isFocused)
                    .padding()
               
                Divider()
                
                HStack {
                    Text(loc_category)
                        .foregroundColor(Color.tix)
                        .frame(alignment: .leading)
                        .padding()
                    
                    Spacer()
                    
                    Picker(loc_choose_category, selection: $cat) {
                                    ForEach(categories, id: \.self) { catt in
                                        Text(catt.name ?? "")
                                            .frame(alignment: .leading)
                                            .frame(maxWidth: .infinity)
                                            .foregroundColor(catt.color?.color ?? Color.tix)
                                    }
                                }.onChange(of: cat, perform: { (value) in
                                    pickerChanged()
                                })
                        .frame(alignment: .trailing)
                        .padding()
                   
                       
                }
                
                Divider()
                
                DatePicker(selection: $dueDate, displayedComponents: .date) {
                    Text(loc_duedate)
                    
                }.foregroundColor(Color.tix)
                .padding()
                .accentColor(Color.tix)
                
                Divider()
                
                Toggle(isOn: self.$important) {
                        Text(loc_important)
                            .foregroundColor(.tix).frame(alignment: .trailing)
                }
                .padding()
                .accentColor(Color.tix)
                Spacer()
                Spacer()
            }.toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button(action: {
                        withAnimation {
                            cancelAction()
                            Haptics.giveSmallHaptic()
                        }
                    }) {
                        Text(loc_discard)
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
                        Text(loc_save)
                            .foregroundColor(.tix)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                }
            }.navigationBarTitle(self.toDoText, displayMode: .automatic)
             .allowsTightening(true)
             .accentColor(.tix)
        }
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
        
        isFocused = true
        todo = "\(loc_new_todo)"
        
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
        newTodo.todo = self.todo
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
