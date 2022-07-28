//
//  Photo.swift
//  milestone P10-12
//
//  Created by Gökhan on 27.07.2022.
//

import UIKit

class Photo: NSObject, Codable {
    var path: URL
    var caption: String
    
    init(path: URL, caption: String) {
        self.path = path
        self.caption = caption
    }
}
