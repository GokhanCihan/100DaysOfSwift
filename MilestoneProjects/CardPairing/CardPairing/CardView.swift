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
        self.isUserInteractionEnabled = true
    }
    
}
extension CardView {
    func configureView() {
        kanjiImageView.translatesAutoresizingMaskIntoConstraints = false
        kanjiImageView.layer.borderColor = UIColor.green.cgColor
        kanjiImageView.layer.borderWidth = 4
        self.addSubview(kanjiImageView)
        
        reading.translatesAutoresizingMaskIntoConstraints = false
        reading.layer.borderColor = UIColor.red.cgColor
        reading.layer.borderWidth = 3
        self.addSubview(reading)
        
        meaningEN.translatesAutoresizingMaskIntoConstraints = false
        meaningEN.layer.borderColor = UIColor.blue.cgColor
        meaningEN.layer.borderWidth = 3
        self.addSubview(meaningEN)
        
        // subviews' constraints
        NSLayoutConstraint.activate([
            kanjiImageView.topAnchor.constraint(equalTo: self.topAnchor),
            kanjiImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            kanjiImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            kanjiImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8),
            
            reading.topAnchor.constraint(equalTo: kanjiImageView.bottomAnchor),
            reading.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            reading.widthAnchor.constraint(equalTo: self.widthAnchor),
            reading.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.1),
            
            meaningEN.topAnchor.constraint(equalTo: reading.bottomAnchor),
            meaningEN.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            meaningEN.widthAnchor.constraint(equalTo: self.widthAnchor),
            meaningEN.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.1)
        ])
    }
}
