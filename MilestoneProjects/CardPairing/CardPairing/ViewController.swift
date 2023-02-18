//
//  ViewController.swift
//  CardPairing
//
//  Created by Gökhan on 26.01.2023.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    enum Status {
        case allDown
        case searchingPair
        case win
    }

    enum Result {
        case fail
        case success
    }

    var status = Status.allDown

    var match: Result? {
        didSet { endMatch(match) }
    }

    var firstCard = CardView()
    var secondCard = CardView()

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
        let formatter = DataFormatter()

        for number in 0..<self.numberOfPairs {
            let pairs = formatter.createPairs(number)

            self.pairArray.append(pairs.0)
            self.pairArray.append(pairs.1)
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
            card.pair = pair

            attachTapGestureRecognizer(to: card)
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

    func attachTapGestureRecognizer(to card: CardView) {
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: #selector(handleTapGesture))
        tapGestureRecognizer.delegate = self

        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.delaysTouchesBegan = false

        card.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func handleTapGesture(_ sender: UITapGestureRecognizer) {
        if let viewTapped = sender.view as? CardView {
            switch self.status {
            case .allDown:
                self.firstCard = viewTapped
                firstCard.flipSide()

                self.status = .searchingPair
            case .searchingPair:
                self.secondCard = viewTapped
                self.secondCard.flipSide()

                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    if let pair = self.firstCard.pair, let otherPair = self.secondCard.pair {
                        if pair.isMatch(of: otherPair){
                            self.match = .success
                        } else {
                            self.match = .fail
                        }
                    }
                }
            case .win:
                self.alertWin()
            }
        }
    }

    func endMatch(_ result: Result?) {
        if let result = result {
            switch result {
            case .success:
                self.verticalStackView.removeArrangedSubview(self.firstCard)
                self.verticalStackView.removeArrangedSubview(self.secondCard)
            case .fail:
                self.firstCard.flipSide()
                self.secondCard.flipSide()
            }
            self.status = .allDown
        }
    }

    func alertWin() {
        let ac = UIAlertController(title: "W I N !", message: "You have succesfully matched all cards.\n\tCongratulations!!!", preferredStyle: .actionSheet)
        
        ac.addAction(UIAlertAction(title: "Start New Game", style: .default) { _ in
            // Game starts again
        })
        ac.addAction(UIAlertAction(title: "Stay", style: .cancel) { ac in
            // Show final game screen
        })
        ac.addAction(UIAlertAction(title: "Quit Game", style: .destructive) { _ in
            // Exit
        })

        self.present(ac, animated: true)
    }
}
