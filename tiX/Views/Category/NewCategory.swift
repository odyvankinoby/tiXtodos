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
    
    @State var cat = "Name"
    @State var col = Color.tix
    @FocusState private var isFocused: Bool
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                TextField(loc_new_cat, text: self.$cat)
                    .frame(alignment: .leading)
                    .frame(maxWidth: .infinity)
                    .font(.title2)
                    .opacity(cat.isEmpty ? 0.5 : 1)
                    .foregroundColor(Color.tix)
                    .focused($isFocused)
                    .padding()
                Divider()
               
                HStack {
                    Text(loc_color)
                        .foregroundColor(Color.tix)
                        .frame(alignment: .leading)
                    Spacer()
                    Image(systemName: "square.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(self.col)
                    Spacer()
                    ColorPicker("", selection: $col)
                        .frame(alignment: .trailing)
                }.padding()
                Spacer()
                Spacer()
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button(action: {
                        withAnimation {
                            cancelAction()
                            Haptics.giveSmallHaptic()
                        }
                    }) {
                        Text(loc_discard)
                            .foregroundColor(.tix)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                }
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
            .navigationBarTitle(self.cat, displayMode: .automatic)
            .allowsTightening(true)
            .onAppear(perform: onAppear)
            .accentColor(.tix)
        }
    }
    
    func onAppear() {
        isFocused = true
    }
    
    func saveAction() {
        let newC = Category(context: self.viewContext)
        newC.name = self.cat
        newC.color = SerializableColor(from: self.col)
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

