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
    @State var toDoText = ""
    @State var cat: Category
    @State var col = Color.tix
    @State var important = false
    
    var body: some View {
        
        VStack {
            ScrollView() {
                Text(loc_todo)
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
                
                Text(loc_category)
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
                   
                }.padding()
               
              
                
                Text(loc_duedate)
                    .frame(alignment: .leading)
                    .frame(maxWidth: .infinity)
                    .padding().background(Color.tix.opacity(0.5))
                DatePicker(selection: $dueDate, displayedComponents: .date) {
                    Text(loc_duedate)
                    
                }
                .foregroundColor(Color.tix)
                .padding()
                
                
                Text(loc_important)
                    .frame(alignment: .leading)
                    .frame(maxWidth: .infinity)
                    .padding().background(Color.tix.opacity(0.5))
                Toggle(isOn: self.$important) {
                        Text(loc_important)
                            .foregroundColor(.tix).frame(alignment: .trailing)
                }
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
                    Text(loc_save)
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
        todo.todo = self.toDoText
        todo.dueDate = self.dueDate
        todo.important = self.important
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
