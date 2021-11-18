//
//  TodoEdit.swift
//  tiX
//
//  Created by Nicolas Ott on 06.11.21.
//
import SwiftUI
import CoreData

struct TodoEdit: View {
    
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @FetchRequest(entity: Category.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)]) var categories: FetchedResults<Category>
    
    @ObservedObject var settings: UserSettings
    @State var todo: Todo
    @Binding var inlineEdit: Bool
    @Binding var inlineItem: UUID
    @State var inlineTodo: String
    @State var inlineText: String
    @FocusState var isFocused: Bool
    @State var cat: Category
    @State var hasDD: Bool
    @State var dd: Date
    @State var prio: Bool
    @Binding var accentColor: Color
    @State var showPicker = false
    
    @State var fgColor: Color = Color.tix
    
    var body: some View {
        VStack {
            HStack{
                Button(action: {
                    withAnimation {
                        ViewContextMethods.deleteItem(todo: todo, context: viewContext)
                        endInlineEdit()
                    }
                }) {
                    Text(loc_delete).foregroundColor(Color(settings.globalForeground))
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
                        ViewContextMethods.saveItem(
                            todo: todo,
                            toDoText: inlineTodo,
                            text: inlineText,
                            hasDD: hasDD,
                            dueDate: dd,
                            prio: prio,
                            cat: cat,
                            context: viewContext)
                        inlineEdit = false
                        inlineItem = UUID()
                        accentColor = Color(settings.globalText)
                    }
                }) {
                    Image(systemName: "checkmark.circle")
                        .resizable()
                        .frame(width: 24, height: 24, alignment: .top)
                        .foregroundColor(inlineTodo.isEmpty ? Color(settings.globalForeground).opacity(0.5) : Color(settings.globalForeground))
                }.disabled(inlineTodo.isEmpty)
            }
            
            
            VStack(alignment: .leading) {
                
                HStack(alignment: .center) {
                    Image(systemName: todo.isDone ? "circle.fill" : "circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .onTapGesture {
                            withAnimation {
                                ViewContextMethods.isDone(todo: todo, context: viewContext)
                                fgColor = todo.todoCategory?.color?.color.opacity(todo.isDone ? 0.5 : 1) ?? Color.tix.opacity(todo.isDone ? 0.5 : 1)
                            }
                        }
                        .foregroundColor(fgColor)
                        .padding(.trailing, 10)
                    
                    ZStack(alignment: .topLeading) {
                        if inlineTodo.isEmpty {
                            Text(loc_todo)
                                .foregroundColor(Color(UIColor.placeholderText))
                                .padding(.horizontal, 4)
                                .padding(.vertical, 8)
                                .font(.headline)
                                .background(Color.clear)
                        }
                        TextEditor(text: $inlineTodo)
                            .keyboardType(.default)
                            .font(.headline)
                            .foregroundColor(fgColor)
                            .focused($isFocused)
                            .background(Color.clear)
                    }.onDisappear(perform: {
                        isFocused = false
                        accentColor = Color.white
                    })
                    Spacer()
                }
                Divider()
                
                ZStack(alignment: .topLeading) {
                    if inlineText.isEmpty {
                        Text(loc_notes)
                            .foregroundColor(Color(UIColor.placeholderText))
                            .padding(.horizontal, 4)
                            .padding(.vertical, 8)
                    }
                    TextEditor(text: $inlineText).keyboardType(.default)
                        .foregroundColor(Color.tix)
                        .background(Color.clear)
                        .multilineTextAlignment(.leading)
                        .lineLimit(10)
                }
                Divider()
                
                HStack {
                    Text(loc_category)
                        .foregroundColor(fgColor)
                        .frame(alignment: .leading)
                    Spacer()
                    Image(systemName: "square.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(fgColor)
                    Picker(loc_choose_category, selection: $cat) {
                        ForEach(categories, id: \.self) { catt in
                            Text(catt.name ?? "")
                                    .frame(alignment: .leading)
                        }
                    }
                    .onChange(of: cat, perform: { (value) in
                        cat = value
                        fgColor = cat.color?.color.opacity(todo.isDone ? 0.5 : 1) ?? Color.tix.opacity(todo.isDone ? 0.5 : 1)
                    })
                    .frame(alignment: .trailing)
                    
                }
                
                HStack {
                    Toggle(isOn: $hasDD) {
                        Text(loc_set_duedate)
                            .foregroundColor(fgColor)
                            .frame(alignment: .trailing)
                    }
                    .accentColor(fgColor)
                }
                
                
                if hasDD {
                    DatePicker(selection: $dd, displayedComponents: .date) {
                        Text(loc_duedate)
                        
                    }
                    .foregroundColor(fgColor)
                    .accentColor(fgColor)
                }
                
                Toggle(isOn: $prio) {
                    Text(loc_important)
                        .foregroundColor(fgColor)
                        .frame(alignment: .trailing)
                }
                .accentColor(fgColor)
            }
            .frame(maxWidth: .infinity, minHeight: 150, maxHeight: .infinity)
            .padding()
            .background(RoundedCorners(color: Color.white, tl: 10, tr: 10, bl: 10, br: 10))
            .cornerRadius(10)
            .frame(maxWidth: .infinity)
            .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(settings.globalBackground == "White" ? Color.tix : Color(settings.globalForeground), lineWidth: 1).padding(1)
                )
        }
        .onAppear(perform: onAppear)
        .onAppear(perform: onDisappear)
    }
    
    private func onAppear() {
        isFocused = true
        fgColor = todo.todoCategory?.color?.color.opacity(todo.isDone ? 0.5 : 1) ?? Color.tix.opacity(todo.isDone ? 0.5 : 1)
    }
    
    private func onDisappear() {
        self.accentColor = Color(settings.globalText)
    }
    
    private func endInlineEdit() {
        inlineEdit = false
        inlineItem = UUID()
        self.presentationMode.wrappedValue.dismiss()
    }
    
}
private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    //formatter.timeStyle = .short
    return formatter
}()
