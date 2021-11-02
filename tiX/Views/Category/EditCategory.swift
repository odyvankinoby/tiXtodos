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
    @Environment(\.presentationMode) var presentationMode
    
    @State private var catText = ""
    @State var col = Color.tix
    @FocusState private var isFocused: Bool
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading) {

                TextField(loc_category, text: $catText)
                    .frame(alignment: .leading)
                    .frame(maxWidth: .infinity)
                    .opacity(catText.isEmpty ? 0.25 : 1)
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
               

            }
            
      
        .onAppear(perform: onAppear)
        .navigationBarTitle(self.catText, displayMode: .automatic).allowsTightening(true)
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
        catText = cat.name ?? ""
        col = cat.color?.color ?? Color.tix
    }
    
    func saveAction() {
        cat.name = self.catText
        cat.color = SerializableColor(from: self.col)
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
