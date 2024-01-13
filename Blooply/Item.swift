//
//  Item.swift
//  Blooply
//
//  Created by Miguel Ferreira on 12/01/2024.
//

import Foundation
import SwiftData

@Model
final class Convo {
    var timestamp: Date
    var icon: String
    var title: String
    var lastResponse: String
    
    init(timestamp: Date, icon: String, title: String, lastResponse: String) {
        self.timestamp = timestamp
        self.icon = icon
        self.title = title
        self.lastResponse = lastResponse
    }
}
