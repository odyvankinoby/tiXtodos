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
    
    @State var dueDate = Date()
    @State var toDoText = ""
    @State var cat: Category
    @State var col: Color
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
        col = cat.color?.color ?? Color.tix
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
