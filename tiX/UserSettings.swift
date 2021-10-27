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
    @Published var deleteTicked: Bool { didSet { UserDefaults.standard.set(deleteTicked, forKey: "deleteTicked") } }
   
    init() {
        self.hideTicked = UserDefaults.standard.object(forKey: "hideTicked") as? Bool ?? false
        self.deleteTicked = UserDefaults.standard.object(forKey: "deleteTicked") as? Bool ?? false
    }
}
