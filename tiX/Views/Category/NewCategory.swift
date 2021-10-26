//
//  NewCategory.swift
//  tiX
//
//  Created by Nicolas Ott on 26.10.21.
//

import SwiftUI
import Combine


struct NewCategory: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @State var cat = ""
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Category", text: self.$cat)
                    .foregroundColor(.tix)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
            }
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
        }.navigationBarTitle("New Category", displayMode: .automatic).allowsTightening(true)
    }
    
    func saveAction() {
        let newC = Category(context: self.viewContext)
        newC.category = self.cat
        newC.id = UUID()
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

