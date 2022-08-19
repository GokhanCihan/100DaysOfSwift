//
//  Country.swift
//  milestone P13-15 (country details)
//
//  Created by Gökhan on 10.08.2022.
//

import Foundation

struct Country: Codable {
    var name: Name
    var unMember: Bool
    var currencies: Dictionary<String, Dictionary<String, String>>
    var capital: [String]
    var region: String
    var subregion: String
    var languages: Dictionary<String, String>
    var area: Double
    var flag: String
}
