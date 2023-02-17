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
    var pair: Pair? {
        didSet {
            frontSideView.text = self.pair?.value
        }
    }

    private var side = Side.back
    private var frontSideView = UILabel()
    private var backSideView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.isUserInteractionEnabled = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CardView {
    func configureView() {
        frontSideView.isHidden = true
        backSideView.isHidden = false
        
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.5

        backSideView.translatesAutoresizingMaskIntoConstraints = false
        backSideView.contentMode = .scaleAspectFill
        backSideView.clipsToBounds = true

        backSideView.image = UIImage(named: "BackSide.png")
        self.addSubview(backSideView)

        frontSideView.translatesAutoresizingMaskIntoConstraints = false
        frontSideView.layer.backgroundColor = UIColor.white.cgColor
        frontSideView.font = .systemFont(ofSize: 80, weight: .thin)

        frontSideView.adjustsFontSizeToFitWidth = true
        frontSideView.textAlignment = .center
        self.addSubview(frontSideView)

        // subviews' constraints
        NSLayoutConstraint.activate([
            frontSideView.topAnchor.constraint(equalTo: self.topAnchor),
            frontSideView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            frontSideView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            frontSideView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            backSideView.topAnchor.constraint(equalTo: self.topAnchor),
            backSideView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backSideView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backSideView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    func flipSide() {
        switch self.side {
        case .front:
            self.side = .back
            self.frontSideView.isHidden = true
            self.backSideView.isHidden = false
        case .back:
            self.side = .front
            self.frontSideView.isHidden = false
            self.backSideView.isHidden = true
        }
    }
}
