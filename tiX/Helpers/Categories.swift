//
//  Categories.swift
//  tiX
//
//  Created by Nicolas Ott on 05.10.21.
//

import Foundation
import SwiftUI

struct ItemCategory: Identifiable, Hashable {
    let id = UUID()
    
    var category: String
    var color: Color
}

@available(iOS 15.0, *)
@available(iOS 15.0, *)
@available(iOS 15.0, *)
let categories = [
    ItemCategory(category: "Business", color: Color.cyan),
    ItemCategory(category: "Personal", color: Color.indigo),
    ItemCategory(category: "Other", color: Color.mint)
]
