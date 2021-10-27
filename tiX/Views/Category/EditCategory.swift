//
//  EditCategory.swift
//  tiX
//
//  Created by Nicolas Ott on 26.10.21.
//

import SwiftUI
import Combine

struct EditCategory: View {
    
    @State var cat: Category
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var toDoText = ""
    @State private var selectedColor = "Red"
    var colors = ["Red", "Green", "Blue", "Tartan"]
                    
    let toDoTextLimit = 70
    @State var col = Color.tix
    
    var body: some View {
        
        VStack {
            ScrollView() {
                Text("Category")
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
                Text("Color")
                    .frame(alignment: .leading)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.tix.opacity(0.5))
                Image(systemName: "square.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .onTapGesture {
                        withAnimation {
                            /*ViewContextMethods.isDone(todo: todo, context: viewContext)*/
                        }
                    }
                    .foregroundColor(self.col)
                    .padding(.trailing, 10)
                    .padding(.bottom, 10)
                    .padding(.top, 10)
                
               

            }
            .frame(maxWidth: .infinity)
            .background(Color(UIColor.systemBackground))
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.tix.opacity(0.5), lineWidth: 0.5))
            .padding()
      
        .onAppear(perform: onAppear)
     
        .navigationBarTitle(self.toDoText, displayMode: .automatic).allowsTightening(true)
            
            
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor(.tix) // NAV
    }
    
    func onAppear() {
        toDoText = cat.category ?? ""
        col = cat.color?.color ?? Color.tix
      
    }
    
    func textChanged(upper: Int, text: inout String) {
        if text.count > upper {
            text = String(text.prefix(upper))
        }
    }
    
}
