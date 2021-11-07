//
//  NewCategory.swift
//  tiX
//
//  Created by Nicolas Ott on 26.10.21.
//

import SwiftUI
import Combine


struct CategoryNew: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var settings: UserSettings
    
    @State var cat = "Name"
    @State var col = Color.tix
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    withAnimation {
                        cancelAction()
                        Haptics.giveSmallHaptic()
                    }
                }) {
                    Text(loc_discard)
                        .foregroundColor(.white)
                }
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
                Button(action: {
                    withAnimation {
                        saveAction()
                        Haptics.giveSmallHaptic()
                    }
                }) {
                    Text(loc_save)
                        .foregroundColor(.white)
                }
                .buttonStyle(PlainButtonStyle())
            }.padding(.top).padding(.bottom)
            
            HStack {
                Text(loc_new_cat)
                    .font(.title).bold()
                    .foregroundColor(Color.white)
                    .frame(alignment: .leading)
                    .padding(.top)
                Spacer()
            }
            ScrollView {
                VStack(alignment: .leading) {
                    TextField(loc_new_cat, text: self.$cat)
                        .keyboardType(.default)
                        .font(.title2)
                        .opacity(cat.isEmpty ? 0.5 : 1)
                        .foregroundColor(Color.tix)
                        .focused($isFocused)
                        .background(Color.clear)
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
                            .padding(.bottom)
                    }
                   
                }.padding(.leading)
                .padding(.trailing)
                .padding(.top, 5).padding(.bottom, 5)
                .background(Color.white)
                .cornerRadius(10)
                .frame(maxWidth: .infinity)
            }
        }
        .accentColor(.tix)
        .padding(.leading).padding(.trailing)
        .background(Color(settings.globalBackground))
        .onAppear(perform: onAppear)
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

