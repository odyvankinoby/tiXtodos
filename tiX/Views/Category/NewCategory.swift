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
    @State var col = Color.tix
    
    var body: some View {
        NavigationView {
            ScrollView() {
                Text("Category")
                    .frame(alignment: .leading)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.tix.opacity(0.5))
                TextField("", text: self.$cat)
                    .frame(alignment: .leading)
                    .frame(maxWidth: .infinity)
                    .opacity(cat.isEmpty ? 0.25 : 1)
                    .foregroundColor(Color.tix)
                    .padding()
                Text("Color")
                    .frame(alignment: .leading)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.tix.opacity(0.5))
                ColorPicker("Set Category color", selection: $col)
                    .frame(alignment: .leading)
                    .frame(maxWidth: .infinity)
                    .padding()
                        
            }
            .frame(maxWidth: .infinity)
            .background(Color(UIColor.systemBackground))
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.tix.opacity(0.5), lineWidth: 0.5))
            .padding()
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
            .navigationBarTitle("New Category", displayMode: .automatic).allowsTightening(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor(.tix) // NAV
    }
    
    
    
    func saveAction() {
        let newC = Category(context: self.viewContext)
        newC.category = self.cat
        newC.color = SerializableColor.init(from: self.col)
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

