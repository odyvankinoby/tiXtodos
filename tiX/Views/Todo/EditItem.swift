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
    @FetchRequest(entity: Category.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)]) var categories: FetchedResults<Category>
    
    @State var dueDate = Date()
    @State var todotxt = ""
    @State var cat: Category
    @State var col = Color.tix
    @State var important = false
    @State var hasDueDate = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                TextField(loc_todo, text: $todotxt)
                    .frame(alignment: .leading)
                    .frame(maxWidth: .infinity)
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
                
            }
            .navigationBarTitle(self.todotxt, displayMode: .automatic).allowsTightening(true)
            .toolbar {
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
            .navigationBarTitle(self.todotxt, displayMode: .automatic)
            .allowsTightening(true)
            .accentColor(.tix)
            .onAppear(perform: onAppear)
            .modifier(AdaptsToKeyboard())
        }
    }
    
    func onAppear() {
        isFocused = true
        todotxt = todo.todo ?? ""
        hasDueDate = todo.hasDueDate
        dueDate = todo.dueDate ?? Date()
        important = todo.important
        cat = todo.todoCategory ?? Category()
        col = Color.tix
        if todo.todoCategory != nil {
            col = cat.color?.color ?? Color.tix
        }
    }
    
    func pickerChanged() {
        col = cat.color?.color ?? Color.tix
    }
    
    func textChanged(upper: Int, text: inout String) {
        if text.count > upper {
            text = String(text.prefix(upper))
        }
    }
    
    func saveAction() {
        todo.todo = self.todotxt
        todo.dueDate = self.dueDate
        todo.important = self.important
        todo.hasDueDate = self.hasDueDate
        if self.hasDueDate {
            todo.dueDate = self.dueDate
        } else {
            todo.dueDate = nil
        }
        todo.todoCategory = self.cat
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
