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
    var side = Side.front
    var pairsID: UUID?
    
    //front side of the card
    var frontSideView = UILabel()
    
    //back side of the card
    var backSideView = UIImageView()
    
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
        self.layer.backgroundColor = UIColor.secondarySystemBackground.cgColor
        self.layer.borderWidth = 1
        
        if side == .back {
            frontSideView.isHidden = true
            backSideView.isHidden = false
        }else {
            frontSideView.isHidden = false
            backSideView.isHidden = true
        }
        
        backSideView.translatesAutoresizingMaskIntoConstraints = false
        backSideView.image = UIImage(named: "BackSide.png")
        self.addSubview(backSideView)
        
        frontSideView.translatesAutoresizingMaskIntoConstraints = false
        frontSideView.adjustsFontSizeToFitWidth = true
        frontSideView.font = UIFont.boldSystemFont(ofSize: 80)
        frontSideView.textAlignment = .center
        self.addSubview(frontSideView)
        
        // subviews' constraints
        NSLayoutConstraint.activate([
            frontSideView.topAnchor.constraint(equalTo: self.topAnchor),
            frontSideView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            frontSideView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            frontSideView.heightAnchor.constraint(equalTo: self.heightAnchor),
            backSideView.topAnchor.constraint(equalTo: self.topAnchor),
            backSideView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backSideView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backSideView.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
    }
}
