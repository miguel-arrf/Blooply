//
//  Item.swift
//  Blooply
//
//  Created by Miguel Ferreira on 12/01/2024.
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
