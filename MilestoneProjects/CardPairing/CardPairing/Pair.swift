//
//  Pair.swift
//  CardPairing
//
//  Created by Gökhan on 26.01.2023.
//

struct Pair: Equatable {
    let value: String
    private var match: String?

    init(_ value: String) {
        self.value = value
    }

    static func == (_ lhs: Pair, _ rhs: Pair) -> Bool {
        return lhs.value == rhs.match! || lhs.match! == rhs.value
    }

    mutating func matching(with pair: Pair) -> Pair {
        self.match = pair.value
        return self
    }

    func isMatch(of otherPair: Pair) -> Bool {
        if self == otherPair {
            return true
        } else {
            return false
        }
    }
}
