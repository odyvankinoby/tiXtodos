//
//  EditItem.swift
//  tiX
//
//  Created by Nicolas Ott on 12.10.21.
//

import SwiftUI
import Combine

struct EditItem: View {
    
    @State var item: Item
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var dueDate = Date()
    @State private var toDoText = ""
    
    let toDoTextLimit = 70
    
    var body: some View {
        NavigationView {
            
            VStack {
                
                
                TextEditor(text: $toDoText)
                
                    .frame(height: 200, alignment: .leading)
                    .frame(maxWidth: .infinity)
                    .lineSpacing(5)
                    .onReceive(Just(toDoText)) { toDoText in
                        textChanged(upper: toDoTextLimit, text: &self.toDoText)
                    }
                    .zIndex(1)
                    .opacity(toDoText.isEmpty ? 0.25 : 1)
                
                
                DatePicker(selection: $dueDate, displayedComponents: .date) {
                    Text("Due date")
                    
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .accentColor(Color.indigo)
                .padding()
            }
            .frame(height: 200, alignment: .leading)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 30)
        }
        .onAppear(perform: onAppear)
    }
    
    func onAppear() {
        toDoText = item.toDoText ?? ""
        dueDate = item.dueDate ?? Date()
    }
    
    func textChanged(upper: Int, text: inout String) {
        if text.count > upper {
            text = String(text.prefix(upper))
        }
    }
    
}
