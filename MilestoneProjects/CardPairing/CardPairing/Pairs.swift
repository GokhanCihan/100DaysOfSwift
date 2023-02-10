//
//  Card.swift
//  CardPairing
//
//  Created by Gökhan on 26.01.2023.
//

import Foundation

struct Pairs {
    let id = UUID()
    var pairOne: String
    var pairTwo: String
    //pairs' image URL as string if exists
    var pairOneURL: String?
    var pairTwoURL: String?
}
