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
        kanjiImageView.layer.borderColor = UIColor.black.cgColor
        kanjiImageView.layer.borderWidth = 1
        
        self.addSubview(kanjiImageView)
        
        if let superview = self.superview {
            NSLayoutConstraint.activate([
                kanjiImageView.topAnchor.constraint(equalTo: superview.topAnchor),
                kanjiImageView.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
                kanjiImageView.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
                kanjiImageView.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            ])
        }
    }
}
