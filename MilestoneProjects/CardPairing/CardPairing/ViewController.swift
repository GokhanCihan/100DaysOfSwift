//
//  ViewController.swift
//  CardPairing
//
//  Created by Gökhan on 26.01.2023.
//

import UIKit

class ViewController: UIViewController {
    let amountOfCards = 16
    var pairsArray = [String]()
    var cardViews = [CardView]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureData()
        self.configureLayout()
    }

    func configureData() {
        for _ in 0..<self.amountOfCards {
            let pairs = Pairs(pairOne: "pairOne", pairTwo: "pairTwo")
            self.pairsArray.append(pairs.pairOne)
            self.pairsArray.append(pairs.pairTwo)
            
            let cardView = CardView()
            self.cardViews.append(cardView)
        }
    }
    
    func configureLayout() {
        let viewWidthUsed = self.view.safeAreaLayoutGuide.layoutFrame.width - 100
        let viewHeightUsed = self.view.safeAreaLayoutGuide.layoutFrame.height - 100
        print("safeArea W: \(viewWidthUsed)\nsafeArea H: \(viewHeightUsed)")
        
        let cardWidth = 0.2 * viewWidthUsed
        let cardHeight = 0.2 * viewHeightUsed
        print("card W: \(cardWidth)\ncard H: \(cardHeight)")
        
        let marginFromSibling = CGPoint(x: 0.25 * cardWidth, y: 0.25 * cardHeight)
        print("marginFromSibling X: \(marginFromSibling.x)\nmarginFromSibling Y: \(marginFromSibling.y)")
        
        // How many points away from screen edge the first line of cards should be
        let marginFromSafeArea = CGPoint(
            x: (viewWidthUsed - 4 * cardWidth - 3 * marginFromSibling.x) / 2 + 50,
            y: (viewHeightUsed - 4 * cardHeight - 3 * marginFromSibling.y) / 2 + 50
        )
        print("marginFromSafeArea X: \(marginFromSafeArea.x)\nmarginFromSafeArea Y: \(marginFromSafeArea.y)\n\n\n")
        for row in 0..<4{
            for column in 0..<4{
                let index = 4 * row + column
                cardViews[index].frame = CGRect(
                    x: Int(marginFromSafeArea.x + CGFloat(column) * (cardWidth + marginFromSibling.x)),
                    y: Int(marginFromSafeArea.y + CGFloat(row) * (cardHeight + marginFromSibling.y)),
                    width: Int(cardWidth),
                    height: Int(cardHeight)
                )
                self.view.addSubview(cardViews[index])
                self.cardViews[index].configureView()
            }
        }
    }
}

