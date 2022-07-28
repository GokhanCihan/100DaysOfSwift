//
//  Photo.swift
//  milestone P10-12
//
//  Created by Gökhan on 27.07.2022.
//

import UIKit

class Photo: NSObject, Codable {
    var name: String
    var caption: String
    
    init(name: String, caption: String) {
        self.name = name
        self.caption = caption
    }
}
