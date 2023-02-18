//
//  ViewController.swift
//  CardPairing
//
//  Created by Gökhan on 26.01.2023.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    enum Status {
        case searching
        case success
        case fail
        case win
    }

    var verticalStackView = UIStackView()

    var status = Status.searching

    var pairArray = [Pair]()
    var cards = [CardView]()
    var flippedCards = [CardView]()
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
        if let viewAttached = sender.view as? CardView {
            flippedCards.append(viewAttached)
            viewAttached.flipSide()
            if flippedCards.count == 2 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.matchResult()
                }
            }
        }
    }

    func matchResult() {
        if let pair = flippedCards[0].pair, let otherPair = flippedCards[1].pair {
            if pair.isMatch(of: otherPair){
                self.status = .success
            } else {
                self.status = .fail
            }
        } else {
            fatalError("Found nil: no pairs to compare etc!!!!")
        }
        self.updateGame()
    }

    func updateGame() {
        switch self.status {
        case .success:
            self.flippedCards.forEach{ verticalStackView.removeArrangedSubview($0) }
            self.flippedCards.removeAll()
            self.status = .searching
        case .fail:
            self.flippedCards.forEach{ $0.flipSide() }
            self.flippedCards.removeAll()
        case .win:
            // Alert WIN
            print("win")
        default:
            break
        }
    }
}
