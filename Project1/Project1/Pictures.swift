//
//  Pictures.swift
//  Project1
//
//  Created by Gökhan on 24.07.2022.
//

import UIKit

class Pictures: NSObject {
    var imageName: UILabel
    var imageViewCount: Int
    
    init(imageName: UILabel, imageViewCount: Int) {
        self.imageName = imageName
        self.imageViewCount = imageViewCount
    }
    
}
