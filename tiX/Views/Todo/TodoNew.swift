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
    @ObservedObject var settings: UserSettings
    
    @FetchRequest(entity: Category.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)]) var categories: FetchedResults<Category>
    
    @State private var dueDate = Date()
    @State private var todo = "Todo"
    @State private var important = false
    @State private var hasDueDate = false
    @FocusState private var isFocused: Bool
    
    @State var cat: Category
    @State var col = Color.tix
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    withAnimation {
                        cancelAction()
                        Haptics.giveSmallHaptic()
                    }
                }) {
                    Text(loc_discard)
                        .foregroundColor(.white)
                }
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
                Button(action: {
                    withAnimation {
                        saveAction()
                        Haptics.giveSmallHaptic()
                    }
                }) {
                    Text(loc_save)
                        .foregroundColor(.white)
                }
                .buttonStyle(PlainButtonStyle())
            }.padding(.top).padding(.bottom)
            
            HStack {
                Text(loc_new_todo)
                    .font(.title).bold()
                    .foregroundColor(Color.white)
                    .frame(alignment: .leading)
                    .padding(.top)
                Spacer()
                if important {
                    Image(systemName: "exclamationmark.circle")
                        .font(.title2)
                        .foregroundColor(Color.red)
                        .padding(.top)
                }
            }
            
            ScrollView {
                VStack(alignment: .leading) {
                    
                    TextEditor(text: $todo)
                        .keyboardType(.default)
                        .focused($isFocused)
                        .font(.title2)
                        .foregroundColor(Color.tix)
                        .opacity(todo == "Todo" ? 0.5 : 1)
                        .background(Color.clear)
                        .multilineTextAlignment(.leading)
                        .lineLimit(5)
                    Divider()
                    HStack {
                        Text(loc_category)
                            .foregroundColor(Color.tix)
                            .frame(alignment: .leading)
                            //.padding()
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
                        //.padding()
                        
                    }
                    
                    Divider()
                    
                    Toggle(isOn: self.$hasDueDate) {
                        Text(loc_set_duedate)
                            .foregroundColor(.tix).frame(alignment: .trailing)
                    }
                    //.padding()
                    .accentColor(Color.tix)
                    if hasDueDate {
                        DatePicker(selection: $dueDate, displayedComponents: .date) {
                            Text(loc_duedate)
                            
                        }.foregroundColor(Color.tix)
                            //.padding()
                            .accentColor(Color.tix)
                    }
                    Divider()
                    
                    Toggle(isOn: self.$important) {
                        Text(loc_important)
                            .foregroundColor(.tix).frame(alignment: .trailing)
                    }
                    //.padding()
                    .accentColor(Color.tix)
                    Spacer()
                    
                }.padding(.leading)
                    .padding(.trailing)
                    .padding(.top, 5).padding(.bottom, 5)
                    .background(Color.white)
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity)
                
                
                
            }
            
        }
        .accentColor(.tix)
        .padding(.leading).padding(.trailing)
        .background(Color(settings.globalBackground))
        .onAppear(perform: onAppear)
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
