//
//  CategoryHelper.swift
//  tiX
//
//  Created by Nicolas Ott on 16.11.21.
//

import SwiftUI
import CoreData

class DefaultCategory: NSObject, ObservableObject {
    
    @Published var defaultCategory = Category()
    
    func getDefault(viewContext: NSManagedObjectContext) {
        let setRequest = NSFetchRequest<Category>(entityName: "Category")
        let setPredicate = NSPredicate(format: "isDefault == true")
        let setSortDescriptor1 = NSSortDescriptor(keyPath: \Category.timestamp, ascending: false)
        setRequest.predicate = setPredicate
        setRequest.sortDescriptors = [setSortDescriptor1]
        do {
            let cats = try viewContext.fetch(setRequest) as [Category]
            /*if cats.count > 1 {
                print("Merging Inboxes")
                for first in cats {
                    mergeInbox(first: first, viewContext: viewContext)
                    mergeEmpty(first: first, viewContext: viewContext)
                    self.defaultCategory = first
                    
                }
            } else */
            if cats.count == 1 {
                for cat in cats {
                    //mergeEmpty(first: cat, viewContext: viewContext)
                    self.defaultCategory = cat
                    
                }
            } else {
                createInbox(viewContext: viewContext)
            }
        } catch let error {
            NSLog("error in FetchRequest trying to get default category: \(error.localizedDescription)")
        }
    }
    
    private func mergeInbox(first: Category, viewContext: NSManagedObjectContext) {
        
        let setRequest = NSFetchRequest<Category>(entityName: "Category")
        let setPredicate = NSPredicate(format: "isDefault == true")
        let setSortDescriptor1 = NSSortDescriptor(keyPath: \Category.timestamp, ascending: false)
        setRequest.predicate = setPredicate
        setRequest.sortDescriptors = [setSortDescriptor1]
        do {
            let inboxes = try viewContext.fetch(setRequest) as [Category]
            for cat in inboxes {
                if cat != first {
                    let tdR = NSFetchRequest<Todo>(entityName: "Todo")
                    let tdrPred = NSPredicate(format: "todoCategory == %@", first as CVarArg)
                    tdR.predicate = tdrPred
                    do {
                        let mergeTodos = try viewContext.fetch(tdR) as [Todo]
                        for td in mergeTodos {
                            td.todoCategory = first
                            do {
                                try viewContext.save()
                            } catch {
                                NSLog(error.localizedDescription)
                            }
                        }
                    }
                    catch let error {
                        NSLog("error in FetchRequest trying to get todos in default category to be merged: \(error.localizedDescription)")
                    }
                    viewContext.delete(cat)
                    do {
                        try viewContext.save()
                    } catch {
                        NSLog(error.localizedDescription)
                    }
                }
            }
        }
        catch let error {
            NSLog("error in FetchRequest trying to get default category: \(error.localizedDescription)")
        }
    }
    
    private func createInbox(viewContext: NSManagedObjectContext) {

        let newC = Category(context: viewContext)
        newC.name = "Inbox"
        newC.isDefault = true
        newC.timestamp = Date()
        newC.color = SerializableColor(from: Color.tix)
        newC.id = UUID()
        do {
            try viewContext.save()
            self.defaultCategory = newC
        } catch {
            NSLog(error.localizedDescription)
        }
    }

    private func mergeEmpty(first: Category, viewContext: NSManagedObjectContext) {
        
        let tdR = NSFetchRequest<Todo>(entityName: "Todo")
        let tdrPred = NSPredicate(format: "todoCategory == nil")
        tdR.predicate = tdrPred
        do {
            let mergeTodos = try viewContext.fetch(tdR) as [Todo]
            for td in mergeTodos {
                td.todoCategory = first
                do {
                    try viewContext.save()
                } catch {
                    NSLog(error.localizedDescription)
                }
            }
        }
        catch let error {
            NSLog("error in FetchRequest trying to get todos in default category to be merged: \(error.localizedDescription)")
        }
    }
     
}





