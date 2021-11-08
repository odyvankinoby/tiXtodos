//
//  EditCategory.swift
//  tiX
//
//  Created by Nicolas Ott on 26.10.21.
//

import SwiftUI
import Combine

struct CategoryEdit: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var settings: UserSettings
    
    @State var cat: Category
    @Binding var inlineEdit: Bool
    @Binding var inlineItem: UUID
    @State var inlineCat: String
    @State var inlineColor: Color
    @Binding var accentColor: Color
    
    @FocusState var isFocused: Bool
    //@State var col = Color.tix
    
    
    var body: some View {
        VStack {
            HStack{
                if !cat.isDefault {
                    Button(action: {
                        withAnimation {
                            ViewContextMethods.deleteCategory(cat: cat, context: viewContext)
                            endInlineEdit()
                        }
                    }) {
                        Text(loc_delete).foregroundColor(Color(settings.globalForeground))
                    }
                }
                Spacer()
                Button(action: {
                    withAnimation {
                        endInlineEdit()
                    }
                }) {
                    Image(systemName: "arrow.uturn.backward.circle").resizable()
                        .frame(width: 24, height: 24, alignment: .top).foregroundColor(Color(settings.globalForeground))
                }
                Button(action: {
                    withAnimation {
                        ViewContextMethods.saveCategory(
                            cat: self.cat,
                            name: self.inlineCat,
                            col: self.inlineColor,
                            context: viewContext)
                        inlineEdit = false
                        inlineItem = UUID()
                    }
                }) {
                    Image(systemName: "checkmark.circle").resizable()
                        .frame(width: 24, height: 24, alignment: .top).foregroundColor(Color(settings.globalForeground))
                }
            }
            
            
            VStack(alignment: .leading) {
                
                HStack(alignment: .center) {
                    
                    TextField(loc_category, text: $inlineCat)
                        .keyboardType(.default)
                        .focused($isFocused)
                        .font(.headline)
                        .background(Color.clear)
                        .opacity(inlineCat.isEmpty ? 0.25 : 1)
                        .foregroundColor(Color.tix)
                        .focused($isFocused)
                        .onDisappear(perform: {
                            isFocused = false
                            accentColor = Color.white
                        })
                }
                
                Divider()
                HStack {
                    Text(loc_color)
                        .foregroundColor(Color.tix)
                        .frame(alignment: .leading)
                    Spacer()
                    Image(systemName: "square.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(self.inlineColor)
                    Spacer()
                    ColorPicker("", selection: $inlineColor)
                        .frame(alignment: .trailing)
                }
                
                if cat.isDefault {
                    Divider()
                    HStack {
                        Spacer()
                        Text(loc_default_cat)
                            .foregroundColor(Color.tix)
                            .frame(alignment: .trailing)
                            .font(.subheadline)
                    }
                }
                
                Spacer()
                
            }
            .frame(maxWidth: .infinity, minHeight: 100, maxHeight: .infinity)
            .padding()
            .background(RoundedCorners(color: Color.white, tl: 10, tr: 10, bl: 10, br: 10))
        }
        .onAppear(perform: onAppear)
        
    }
    
    
    
    private func onAppear() {
        isFocused = true
    }
    
    
    private func endInlineEdit() {
        inlineEdit = false
        inlineItem = UUID()
        self.presentationMode.wrappedValue.dismiss()
    }
    
    
    
}
