//
//  Name.swift
//  milestone P13-15 (country details)
//
//  Created by Gökhan on 13.08.2022.
//

import Foundation

struct Name: Codable {
    var common: String
    var official: String
    var native : Dictionary<String, Dictionary<String, String>>
}
