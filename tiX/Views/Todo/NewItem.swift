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
    @State private var todo = "Todo"
    @State private var important = false
    @State private var hasDueDate = false
    @FocusState private var isFocused: Bool
    
    @State var cat: Category
    @State var col: Color
   
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                TextField(loc_new_todo, text: $todo)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title2)
                    .opacity(todo == "Todo" ? 0.5 : 1)
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
                    Image(systemName: "square.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(col)
                        
                    Picker(loc_choose_category, selection: $cat) {
                        ForEach(categories, id: \.self) { catt in
                            HStack {
                                Text(catt.name ?? "")
                                    .frame(alignment: .leading)
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(catt.color?.color ?? Color.tix)
                                    
                                
                            }
                        }
                    }
                    .onChange(of: cat, perform: { (value) in
                        pickerChanged()
                    })
                    .frame(alignment: .trailing)
                    .padding()
                    
                }
                
                Divider()
                
                Toggle(isOn: self.$hasDueDate) {
                    Text(loc_set_duedate)
                        .foregroundColor(.tix).frame(alignment: .trailing)
                }
                .padding()
                .accentColor(Color.tix)
                if hasDueDate {
                    DatePicker(selection: $dueDate, displayedComponents: .date) {
                        Text(loc_duedate)
                        
                    }.foregroundColor(Color.tix)
                        .padding()
                        .accentColor(Color.tix)
                }
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
            }
            .navigationBarTitle(self.todo, displayMode: .automatic)
            .allowsTightening(true)
            .accentColor(.tix)
            .onAppear(perform: onAppear)
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
        self.col = self.cat.color?.color ?? Color.tix

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
        newTodo.hasDueDate = self.hasDueDate
        if self.hasDueDate {
            newTodo.dueDate = self.dueDate
        } else {
            newTodo.dueDate = nil
        }
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
