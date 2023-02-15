//
//  ViewController.swift
//  CardPairing
//
//  Created by Gökhan on 26.01.2023.
//

import UIKit

class ViewController: UIViewController {
    var verticalStackView = UIStackView()

    var pairArray = [Pair]()
    var cards = [CardView]()

    let numberOfPairs = 8

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureData()
        self.configureLayout()
    }

    func configureData() {
        for _ in 0..<self.numberOfPairs {
            let pairs = Pairs(Pair("円"), Pair("en"))

            self.pairArray.append(pairs.pairOne)
            self.pairArray.append(pairs.pairTwo)
        }

        self.pairArray.shuffle()
    }

    func configureLayout() {
        verticalStackView.layer.backgroundColor = UIColor.secondarySystemBackground.cgColor
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.distribution = .equalCentering
        verticalStackView.alignment = .center
        verticalStackView.axis = .vertical
        self.view.addSubview(verticalStackView)

        // Create cards
        for pair in self.pairArray {
            let card = CardView()

            card.frontSideView.text = pair.value
            cards.append(card)
        }

        // Create rows
        for column in 0..<(cards.count / 4) {
            let horizontalStack = UIStackView()

            horizontalStack.translatesAutoresizingMaskIntoConstraints = false
            horizontalStack.distribution = .equalCentering
            horizontalStack.alignment = .center
            horizontalStack.axis = .horizontal

            for row in 0..<4 {
                let card = cards[column * 4 + row]
                card.configureView()
                horizontalStack.addArrangedSubview(card)

                NSLayoutConstraint.activate([
                    card.heightAnchor.constraint(equalTo: horizontalStack.heightAnchor, constant: -20),
                    card.widthAnchor.constraint(equalTo: horizontalStack.widthAnchor, multiplier: 0.23)
                ])
            }

            verticalStackView.addArrangedSubview(horizontalStack)
        }

        // Vertical Stack Constraints
        NSLayoutConstraint.activate([
            verticalStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            verticalStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            verticalStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])

        // Horizontal Stack Constraints
        verticalStackView.arrangedSubviews.forEach { hStack in
            NSLayoutConstraint.activate([
                hStack.widthAnchor.constraint(equalTo: verticalStackView.widthAnchor, multiplier: 0.95),
                hStack.heightAnchor.constraint(equalTo: verticalStackView.heightAnchor, multiplier: 0.25)
            ])
        }
    }
}
