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
    
    init() {
         self.hideTicked = UserDefaults.standard.object(forKey: "hideTicked") as? Bool ?? false
    }
}
