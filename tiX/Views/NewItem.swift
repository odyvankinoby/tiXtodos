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
    
    @State private var category = "Business"
    @State private var dueDate = Date()
    @State private var toDoText = ""
    
    @Binding var tabSelected: Int
    
    let toDoTextLimit = 70
    
    var body: some View {
        
        ZStack {
            
            ScrollView {
                VStack {
                    Picker(selection: $category,
                           label:
                            Text("\(category)")
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

                    DatePicker(selection: $dueDate, displayedComponents: .date) {
                        Text("Due date")
                        
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .accentColor(Color.indigo)
                    .padding()
                    
                    ZStack(alignment: .leading) {
                        if toDoText.isEmpty {
                            VStack(alignment: .leading) {
                                Text("Enter your todo item")
                                    .font(Font.body)
                                    .foregroundColor(Color.gray)
                                Spacer()
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 4)
                            .zIndex(0)
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
                        
                    }
                    .frame(height: 200, alignment: .leading)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 30)
                    
                    
                    Button(role: .none, action: {
                        ViewContextMethods.addItem(context: viewContext, dueDate: dueDate, toDoText: toDoText, category: category)
                        withAnimation {
                            tabSelected = 1
                        }
                    }, label: {
                        HStack {
                            Text("New task ")
                            Image(systemName: "chevron.up")
                        }
                        .frame(maxWidth: .infinity)
                    })
                      
                    
                }
                .padding(.top, 100)
                .background(Color.white
                                .frame(maxWidth: .infinity, maxHeight: .infinity))
            }
            
            
            VStack{
                HStack{
                    Spacer()
                    Button(action: {
                        withAnimation {
                            tabSelected = 1
                        }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.indigo)
                            .shadow(color: .indigo.opacity(0.3), radius: 10, x: 0, y: 10)
                            .padding()
                    }
                }
                
                Spacer()
            }
        }
        
        
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
