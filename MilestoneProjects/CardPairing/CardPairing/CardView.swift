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
    var frontSideView = UILabel()
    //back side of the card
    var backSideView = UIImage()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
    }
    
}
extension CardView {
    func configureView() {
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 1
        
        frontSideView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(frontSideView)
        
        // subviews' constraints
        NSLayoutConstraint.activate([
            frontSideView.topAnchor.constraint(equalTo: self.topAnchor),
            frontSideView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            frontSideView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            frontSideView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.75),
        ])
    }
}
