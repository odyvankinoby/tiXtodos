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
    
    @State private var dueDate = Date()
    @State private var toDoText = ""
    @State private var category = "Private"
    
    let toDoTextLimit = 70
    
    var body: some View {
        NavigationView {
            VStack {
                /*
                 Picker(selection: $category,
                 label:
                 Text("fefef")
                 .font(.body.bold())
                 .padding()
                 .foregroundColor(.black)
                 .frame(maxWidth: .infinity, alignment: .leading)
                 //.frame(height: 50)
                 .background(
                 ZStack {
                 getCategoryColor(categoryChosen: category).opacity(0.7)
                 .frame(maxWidth: .infinity, maxHeight: .infinity)
                 .padding(.horizontal, 10)
                 .padding(.vertical, 2)
                 VStack {
                 // empty VStack for the blur
                 }
                 .frame(maxWidth: .infinity, maxHeight: .infinity)
                 .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 5))
                 },
                 alignment: .leading
                 )
                 .shadow(color: .black.opacity(0.1), radius: 20, x: 5, y: 10)
                 .shadow(color: .black.opacity(0.1), radius: 1, x: 1, y: 1)
                 .shadow(color: .white.opacity(1), radius: 5, x: -1, y: -1)
                 ) {
                 ForEach(categories, id: \.self) {
                 Text($0.category)
                 .tag($0.category)
                 
                 }
                 }
                 .pickerStyle(MenuPickerStyle())
                 .padding()
                 */
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
                
                
                Button(role: .none, action: {
                    ViewContextMethods.addItem(context: viewContext, dueDate: dueDate, toDoText: toDoText, category: category)
                    
                }, label: {
                    HStack {
                        Text("New task ")
                        Image(systemName: "chevron.up")
                    }
                    .frame(maxWidth: .infinity)
                })
            }
         }.navigationBarTitle("New Todos", displayMode: .automatic).allowsTightening(true)
    }
    
    func textChanged(upper: Int, text: inout String) {
        if text.count > upper {
            text = String(text.prefix(upper))
        }
    }
    
    private func getCategoryColor(categoryChosen: String) -> Color {
        var category: [ItemCategory] {
            categories.filter {
                $0.category == categoryChosen
            }
        }
        return category[0].color
    }
}
