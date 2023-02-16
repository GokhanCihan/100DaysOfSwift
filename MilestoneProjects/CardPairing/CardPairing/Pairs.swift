//
//  Card.swift
//  CardPairing
//
//  Created by Gökhan on 26.01.2023.
//

import Foundation

struct Pairs {
    let pairOne: Pair
    let pairTwo: Pair

    init(_ value: String, _ valueTwo: String) {
        self.pairOne = Pair(value)
        self.pairTwo = Pair(valueTwo)
    }
}

struct Pair: Equatable {
    let value: String

    init(_ value: String) {
        self.value = value
    }

    static func == (_ lhs: Pair, _ rhs: Pair) -> Bool {
        return lhs.value == rhs.value
    }

    func isPartOf(_ pairs: Pairs) -> Bool {
        if self == pairs.pairOne || self == pairs.pairTwo {
            return true
        } else {
            return false
        }
    }
}
