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
    @Published var launchedBefore: Bool {
             didSet {
                 UserDefaults.standard.set(launchedBefore, forKey: "launchedBefore")
             }
    }
    @Published var userName: String { didSet { UserDefaults.standard.set(userName, forKey: "userName") } }
   
    init() {
        self.hideTicked = UserDefaults.standard.object(forKey: "hideTicked") as? Bool ?? false
        self.launchedBefore = UserDefaults.standard.object(forKey: "launchedBefore") as? Bool ?? false
        self.userName = UserDefaults.standard.object(forKey: "userName") as? String ?? ""
        
    }
}
