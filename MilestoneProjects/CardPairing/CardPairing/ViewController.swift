//
//  ViewController.swift
//  CardPairing
//
//  Created by Gökhan on 26.01.2023.
//

import UIKit

class ViewController: UIViewController {
    let amountOfCards = 16
    let backSideImage = UIImage()
    var pairsArray = [Pairs]()
    var cardViews = [CardView]()
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureData()
        self.configureLayout()
    }
    
    func configureData() {
        for _ in 0..<self.amountOfCards {
            let pairs = Pairs(pairOne: "円", pairTwo: "en")
            self.pairsArray.append(pairs)
        }
        
        //distribute pairs
        for index in 0..<self.amountOfCards {
            let cardView = CardView()
            cardView.pairsID = pairsArray[index].id
            
            if index % 2 == 0 {
                cardView.frontSideView.text = pairsArray[index].pairOne
            }else {
                cardView.frontSideView.text = pairsArray[index].pairTwo
            }
            self.cardViews.append(cardView)
        }
    }
    
    func configureLayout() {
        let viewWidthUsed = self.view.safeAreaLayoutGuide.layoutFrame.width - 100
        let viewHeightUsed = self.view.safeAreaLayoutGuide.layoutFrame.height - 100
        
        let cardWidth = 0.2 * viewWidthUsed
        let cardHeight = 0.2 * viewHeightUsed
        
        let marginFromSibling = CGPoint(x: 0.25 * cardWidth, y: 0.25 * cardHeight)
        
        // How many points away from screen edge the first line of cards should be
        let marginFromSafeArea = CGPoint(
            x: (viewWidthUsed - 4 * cardWidth - 3 * marginFromSibling.x) / 2 + 50,
            y: (viewHeightUsed - 4 * cardHeight - 3 * marginFromSibling.y) / 2 + 50
        )

        self.cardViews.shuffle()
        
        //place cards with the specified arrangement 
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

