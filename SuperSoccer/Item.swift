//
//  Item.swift
//  SuperSoccer
//
//  Created by Wesley on 4/4/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
