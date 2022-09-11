//
//  Script.swift
//  Extension
//
//  Created by Gökhan on 10.09.2022.
//

import UIKit

class Script: NSObject, Codable {
    var scriptName: String
    var scriptText: String
    
    init(scriptName: String, scriptText: String) {
        self.scriptName = scriptName
        self.scriptText = scriptText
    }
}
