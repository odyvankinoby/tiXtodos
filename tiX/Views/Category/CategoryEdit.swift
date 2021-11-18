//
//  EditCategory.swift
//  tiX
//
//  Created by Nicolas Ott on 26.10.21.
//

import SwiftUI
import Combine

struct CategoryEdit: View {
    
    @Environment(\.managedObjectContext) var viewContext
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
                    Image(systemName: "checkmark.circle")
                        .resizable()
                        .frame(width: 24, height: 24, alignment: .top)
                        .foregroundColor(inlineCat.isEmpty ? Color(settings.globalForeground).opacity(0.5) : Color(settings.globalForeground))
                }.disabled(inlineCat.isEmpty)
            }
            
            
            VStack(alignment: .leading) {
                
                ZStack(alignment: .topLeading) {
                    if inlineCat.isEmpty {
                        Text(loc_category)
                            .foregroundColor(Color(UIColor.placeholderText))
                            .padding(.horizontal, 4)
                            .padding(.vertical, 8)
                            .font(.headline)
                    }
                    TextEditor(text: $inlineCat)
                        .keyboardType(.default)
                        .font(.headline)
                        .background(Color(settings.globalForeground))
                        .foregroundColor(Color.tix)
                        .focused($isFocused)
                }.onDisappear(perform: {
                    isFocused = false
                    accentColor = Color.white
                })
                
               
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
            .frame(maxWidth: .infinity)
            .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(settings.globalBackground == "White" ? Color.tix : Color(settings.globalForeground), lineWidth: 1).padding(1)
                )
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
