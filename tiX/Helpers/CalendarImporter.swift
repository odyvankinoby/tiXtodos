//
//  CalendarImporter.swift
//  tiX
//
//  Created by Nicolas Ott on 17.11.21.
//

import SwiftUI
import EventKit

class CalendarImporter: NSObject, ObservableObject {
    
    let eventStore = EKEventStore()
    
    func requestAccess() {
        eventStore.requestAccess(to: .event) { (granted, error) in
        }
    }
}
