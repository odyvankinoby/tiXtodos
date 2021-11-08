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
    
    
    
    @Published var launchedBefore: Bool { didSet { UserDefaults.standard.set(launchedBefore, forKey: "launchedBefore") } }
    
    @Published var appVersion: String { didSet { UserDefaults.standard.set(appVersion, forKey: "appVersion") } }
    
    @Published var appBuild: String { didSet { UserDefaults.standard.set(appBuild, forKey: "appBuild") } }
    
    @Published var appVersionString: String { didSet { UserDefaults.standard.set(appVersionString, forKey: "appVersionString") } }
    
    @Published var hideTicked: Bool { didSet { UserDefaults.standard.set(hideTicked, forKey: "hideTicked") } }
    
    @Published var userName: String { didSet { UserDefaults.standard.set(userName, forKey: "userName") } }
    
    @Published var globalBackground: String { didSet { UserDefaults.standard.set(globalBackground, forKey: "globalBackground") } }
    @Published var globalForeground: String { didSet { UserDefaults.standard.set(globalForeground, forKey: "globalForeground") } }
   
    init() {
        self.appVersion = UserDefaults.standard.object(forKey: "appVersion") as? String ?? ""
        self.appBuild = UserDefaults.standard.object(forKey: "appBuild") as? String ?? ""
        self.appVersionString = UserDefaults.standard.object(forKey: "appVersionString") as? String ?? ""
        self.hideTicked = UserDefaults.standard.object(forKey: "hideTicked") as? Bool ?? false
        self.launchedBefore = UserDefaults.standard.object(forKey: "launchedBefore") as? Bool ?? false
        self.userName = UserDefaults.standard.object(forKey: "userName") as? String ?? ""
        self.globalBackground = UserDefaults.standard.object(forKey: "globalBackground") as? String ?? "tix"
        self.globalForeground = UserDefaults.standard.object(forKey: "globalForeground") as? String ?? "White"

    }
}
