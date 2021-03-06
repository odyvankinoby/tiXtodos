//
//  ViewContent.swift
//  tiX
//
//  Created by Nicolas Ott on 05.10.21.
//
import Foundation
import CoreData
import SwiftUI


struct ViewContextMethods {

    static func addItem(
        context: NSManagedObjectContext,
        hasDD: Bool,
        dueDate: Date,
        toDoText: String,
        category: String,
        text: String,
        prio: Bool
    ) {
        withAnimation {
            let newItem = Todo(context: context)
            newItem.timestamp = Date()
            newItem.hasDueDate = hasDD
            newItem.dueDate = dueDate
            newItem.todo = toDoText
            newItem.text = text
            newItem.important = prio
            newItem.isDone = false
            newItem.id = UUID()
            //newItem.category = category
            
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    static func deleteItem(
        todo: Todo,
        context: NSManagedObjectContext) {
        withAnimation {
            context.delete(todo)
        }
        do {
            try context.save()
            
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    static func deleteCategory(
        cat: Category,
        context: NSManagedObjectContext) {
        withAnimation {
            context.delete(cat)
        }
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    static func isDone(
        todo: Todo,
        context: NSManagedObjectContext) {
        withAnimation{
            todo.isDone.toggle()
        }
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    static func saveCategory(
        cat: Category,
        name: String,
        col: Color,
        context: NSManagedObjectContext) {
        withAnimation{
            cat.name = name
            cat.color = SerializableColor(from: col)
        }
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    static func saveItem(
        todo: Todo,
        toDoText: String,
        text: String,
        hasDD: Bool,
        dueDate: Date,
        prio: Bool,
        cat: Category,
        context: NSManagedObjectContext) {
        withAnimation{
            todo.todo = toDoText
            todo.text = text
            todo.hasDueDate = hasDD
            todo.dueDate = dueDate
            todo.important = prio
            todo.todoCategory = cat
        }
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

