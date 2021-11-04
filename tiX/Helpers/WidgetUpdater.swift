//
//  WidgetUpdater.swift
//  tiX
//
//  Created by Nicolas Ott on 29.10.21.
//
import SwiftUI
import WidgetKit

class WidgetUpdater {
    
    @State var one: String
    @State var two: String
    @State var three: String
    @State var oneTicked: Bool
    @State var twoTicked: Bool
    @State var threeTicked: Bool
    @State var open: Int
    
    init(one: String, two: String, three: String, oneTicked: Bool, twoTicked: Bool, threeTicked: Bool, open: Int) {
        self.one = one
        self.two = two
        self.three = three
        self.oneTicked = oneTicked
        self.twoTicked = twoTicked
        self.threeTicked = threeTicked
        self.open = open
    }
    
    
    func updateWidget() {
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func updateValues() {

    
        UserDefaults(suiteName: "group.de.nicolasott.tiX")!.set(self.one, forKey: "one")
        UserDefaults(suiteName: "group.de.nicolasott.tiX")!.set(self.two, forKey: "two")
        UserDefaults(suiteName: "group.de.nicolasott.tiX")!.set(self.three, forKey: "three")
        
        UserDefaults(suiteName: "group.de.nicolasott.tiX")!.set(self.oneTicked, forKey: "oneTicked")
        UserDefaults(suiteName: "group.de.nicolasott.tiX")!.set(self.twoTicked, forKey: "twoTicked")
        UserDefaults(suiteName: "group.de.nicolasott.tiX")!.set(self.threeTicked, forKey: "threeTicked")
        
        UserDefaults(suiteName: "group.de.nicolasott.tiX")!.set(self.open, forKey: "open")
       
        WidgetCenter.shared.reloadAllTimelines()
    }
}


