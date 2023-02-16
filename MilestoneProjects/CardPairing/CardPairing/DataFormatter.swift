//
//  FormatData.swift
//  CardPairing
//
//  Created by Gökhan on 16.02.2023.
//

import Foundation

struct DataFormatter {
    func createPairs(_ index: Int) -> Pairs {
        let mockData = MockData()
        let symbol = mockData.symbol
        let reading = mockData.reading
        
        return Pairs(symbol[index], reading[index])
    }
}
