//
//  FormatData.swift
//  CardPairing
//
//  Created by Gökhan on 16.02.2023.
//

import Foundation

struct DataFormatter {
    func createPairs(_ index: Int) -> (Pair, Pair) {
        let mockData = MockData()
        let symbolData = mockData.symbol
        let readingData = mockData.reading

        var symbol = Pair(symbolData[index])
        var reading = Pair(readingData[index])

        symbol = symbol.matching(with: reading)
        reading = reading.matching(with: symbol)

        return (symbol, reading)
    }
}
