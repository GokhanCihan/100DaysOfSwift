//
//  Card.swift
//  CardPairing
//
//  Created by Gökhan on 26.01.2023.
//

import Foundation

//JLPT proficiency levels
enum JLPT {
    case N5
    case N4
    case N3
    case N2
    case N1
}

struct Card {
    let id = UUID()
    var level: JLPT
    var reading: String
    var meaningEN: String
    var stringForImageURL: String    
}
