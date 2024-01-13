//
//  ConvosManager.swift
//  Blooply
//
//  Created by Miguel Ferreira on 12/01/2024.
//

import Foundation

@Observable
class ConvosManager {
    var expandedConvo: Convo?
    var textfieldIsPressed: Bool = false
    
    func setExpandedConvo(convo: Convo) {
        expandedConvo = convo
    }
    
    func setTextfieldIsPressed(_ isPressed: Bool) {
        textfieldIsPressed = isPressed
    }
}
