//
//  WidgetUpdater.swift
//  tiX
//
//  Created by Nicolas Ott on 29.10.21.
//
import SwiftUI
import WidgetKit
import CoreData

struct WidgetUpdater {
    
    //@Environment(\.managedObjectContext) var viewContext
    
    func updateWidget() {
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func updateValues(one: String, two: String, three: String, oneTicked: Bool, twoTicked: Bool, threeTicked: Bool, open: Int) {
        UserDefaults(suiteName: "group.de.nicolasott.tiX")!.set(one, forKey: "one")
        UserDefaults(suiteName: "group.de.nicolasott.tiX")!.set(two, forKey: "two")
        UserDefaults(suiteName: "group.de.nicolasott.tiX")!.set(three, forKey: "three")
        
        UserDefaults(suiteName: "group.de.nicolasott.tiX")!.set(oneTicked, forKey: "oneTicked")
        UserDefaults(suiteName: "group.de.nicolasott.tiX")!.set(twoTicked, forKey: "twoTicked")
        UserDefaults(suiteName: "group.de.nicolasott.tiX")!.set(threeTicked, forKey: "threeTicked")
        
        UserDefaults(suiteName: "group.de.nicolasott.tiX")!.set(open, forKey: "open")
        
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func getSetValues(viewContext: NSManagedObjectContext) {
        
        let hideTicked = UserDefaults.standard.bool(forKey: "hideTicked")
        var one = ""
        var two = ""
        var three = ""
        var oneTicked = false
        var twoTicked = false
        var threeTicked = false
        var open = 0
        let tdReq = NSFetchRequest<Todo>(entityName: "Todo")
        let setSortDescriptor1 = NSSortDescriptor(keyPath: \Todo.todo, ascending: true)
        //tdReq.fetchLimit = 3
        tdReq.sortDescriptors = [setSortDescriptor1]
        do {
            let sets = try viewContext.fetch(tdReq) as [Todo]
            var i = 0
            open = sets.count
            for cat in sets {
                if i == 0 {
                    if !(hideTicked && cat.isDone) {
                        one = cat.todo ?? "todo"
                        oneTicked = cat.isDone
                    }
                }
                if i == 1 {
                    if !(hideTicked && cat.isDone) {
                        two = cat.todo ?? "todo"
                        twoTicked = cat.isDone
                    }
                }
                if i == 2 {
                    if !(hideTicked && cat.isDone) {
                        three = cat.todo ?? "todo"
                        threeTicked = cat.isDone
                    }
                }
                if !(hideTicked && cat.isDone) { i+=1 }
            }
        } catch let error {
            print("error in FetchRequest trying to get the first three todos for Widget: \(error.localizedDescription)")
        }
        self.updateValues(one: one, two: two, three: three, oneTicked: oneTicked, twoTicked: twoTicked, threeTicked: threeTicked, open: open)
    }
}


