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
                            hasDD: hasDD,
                            dueDate: dd,
                            prio: prio,
                            cat: cat,
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
                    TextEditor(text: $inlineTodo)
                        .keyboardType(.default)
                        .focused($isFocused)
                        .font(.headline)
                        .foregroundColor(fgColor)
                        .background(Color.clear)
                        .onDisappear(perform: {
                            isFocused = false
                            accentColor = Color.white
                        })
                        .multilineTextAlignment(.leading)
                        .lineLimit(5)
                        
                    Spacer()
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
            
        }.onAppear(perform: onAppear)
    }
    
    private func onAppear() {
        isFocused = true
        fgColor = todo.todoCategory?.color?.color.opacity(todo.isDone ? 0.5 : 1) ?? Color.tix.opacity(todo.isDone ? 0.5 : 1)
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
