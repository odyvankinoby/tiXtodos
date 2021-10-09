//
//  UserSettings.swift
//  tiX
//
//  Created by Nicolas Ott on 06.10.21.
//

import Foundation
import SwiftUI
import Combine

class UserSettings: ObservableObject {
    
    @Published var hideTicked: Bool { didSet { UserDefaults.standard.set(hideTicked, forKey: "hideTicked") } }
    @Published var listMode: Bool { didSet { UserDefaults.standard.set(listMode, forKey: "listMode") } }
    
    init() {
        self.hideTicked = UserDefaults.standard.object(forKey: "hideTicked") as? Bool ?? false
        self.listMode = UserDefaults.standard.object(forKey: "listMode") as? Bool ?? false
    }
}
