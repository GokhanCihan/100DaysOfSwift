//
//  CardView.swift
//  CardPairing
//
//  Created by Gökhan on 26.01.2023.
//

import UIKit

enum Side {
    case front
    case back
}
class CardView: UIView {
    var side = Side.back
    
    //front side of the card
    var kanjiImageView = UIImageView()
    var reading = UILabel()
    var meaningEN = UILabel()
    
    //back side of the card
    var backSide = UIImage()
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
}
