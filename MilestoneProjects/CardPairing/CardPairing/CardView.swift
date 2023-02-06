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
    var name = UILabel()
    
    //back side of the card
    var backSide = UIImage()
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
        
        kanjiImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(kanjiImageView)
        
        name.translatesAutoresizingMaskIntoConstraints = false
        name.adjustsFontSizeToFitWidth = true
        name.textAlignment = .center
        self.addSubview(name)
        
        // subviews' constraints
        NSLayoutConstraint.activate([
            kanjiImageView.topAnchor.constraint(equalTo: self.topAnchor),
            kanjiImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            kanjiImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            kanjiImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.75),
            
            name.topAnchor.constraint(equalTo: kanjiImageView.bottomAnchor),
            name.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            name.widthAnchor.constraint(equalTo: self.widthAnchor),
            name.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25),
        ])
    }
}
