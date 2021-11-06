//
//  TodoItem.swift
//  tiX
//
//  Created by Nicolas Ott on 06.11.21.
//

import SwiftUI
import CoreData

struct TodoItem: View {
    
    @Environment(\.managedObjectContext) var viewContext
    @State var todo: Todo
    @Binding var inlineEdit: Bool
    @Binding var inlineItem: UUID
    @State var inlineTodo: String
    @Binding var accentColor: Color
    
    var body: some View {
        VStack {
            // Display Todo
            HStack(alignment: .center){
                Image(systemName: todo.isDone ? "circle.fill" : "circle")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .onTapGesture {
                        withAnimation {
                            ViewContextMethods.isDone(todo: todo, context: viewContext)
                        }
                    }
                    .foregroundColor(todo.todoCategory?.color?.color.opacity(todo.isDone ? 0.5 : 1) ?? Color.tix.opacity(todo.isDone ? 0.5 : 1))
                    .padding(.trailing, 10)
                    .padding(.bottom)
                    .padding(.top)
                VStack(alignment: .leading){
                    HStack(alignment: .top) {
                        Text(todo.todo ?? "\(loc_todo)")
                            .onTapGesture {
                                withAnimation {
                                    if !inlineEdit {
                                        inlineEdit = true
                                        inlineItem = todo.id ?? UUID()
                                        //isFocused = true
                                        inlineTodo = todo.todo ?? ""
                                        accentColor = todo.todoCategory?.color?.color ?? Color.tix
                                    }
                                }
                            }
                            .font(.headline)
                            .foregroundColor(todo.todoCategory?.color?.color.opacity(todo.isDone ? 0.5 : 1) ?? Color.tix.opacity(todo.isDone ? 0.5 : 1))
                        Spacer()
                        Image(systemName: todo.important ? "exclamationmark.circle" : "")
                            .foregroundColor(Color.red.opacity(todo.isDone ? 0.5 : 1))
                    }
                    HStack(alignment: .bottom) {
                        Text(todo.hasDueDate ? "\(todo.dueDate!, formatter: itemFormatter)" : "")
                            .font(.subheadline)
                            .foregroundColor(todo.todoCategory?.color?.color.opacity(todo.isDone ? 0.5 : 1) ?? Color.tix.opacity(todo.isDone ? 0.5 : 1))
                        Spacer()
                        Text(todo.todoCategory!.name ?? "").font(.subheadline)
                            .foregroundColor(todo.todoCategory?.color?.color.opacity(todo.isDone ? 0.5 : 1) ?? Color.tix.opacity(todo.isDone ? 0.5 : 1))
                    }
                }
            }
            .padding(.leading)
            .padding(.trailing)
            .padding(.top, 5).padding(.bottom, 5)
            .background(Color.white)
            .cornerRadius(10)
            .frame(maxWidth: .infinity)
            
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    //formatter.timeStyle = .short
    return formatter
}()
