//
//  Pictures.swift
//  Project1
//
//  Created by Gökhan on 24.07.2022.
//

import UIKit

class Pictures: NSObject, Codable {
    var imageName: String
    var imageViewCount: Int
    
    init(imageName: String, imageViewCount: Int) {
        self.imageName = imageName
        self.imageViewCount = imageViewCount
    }
    
}
