//
//  Formatter.swift
//  tiX
//
//  Created by Nicolas Ott on 30.10.21.
//

import Foundation
import SwiftUI
import Combine

struct Utils {
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        return formatter
    }()
}
