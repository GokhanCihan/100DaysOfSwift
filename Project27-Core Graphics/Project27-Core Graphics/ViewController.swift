//
//  ViewController.swift
//  Project27-Core Graphics
//
//  Created by Gökhan on 11.10.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    
    @IBAction func redrawTapped(_ sender: Any) {
        currentDrawType += 1

        if currentDrawType > 5 {
            currentDrawType = 0
        }

        switch currentDrawType {
        case 0:
            drawRectangle()
        case 1:
            drawCircle()
        case 2:
            drawCheckerboard()
        case 3:
            drawRotatedSquares()
        case 4:
            drawImageAndText()
        case 5:
            drawStarEmoji()
        default:
            break
        }
    }
    
    var currentDrawType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawStarEmoji()
        
    }

    func drawRectangle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

        let img = renderer.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy:5)

            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)

            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }

        imageView.image = img
    }
    
    func drawCircle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

            
        let img = renderer.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)

            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)

            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }

        imageView.image = img
    }
    
    func drawCheckerboard() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

        let img = renderer.image { ctx in
            ctx.cgContext.setFillColor(UIColor.black.cgColor)

            for row in 0 ..< 8 {
                for col in 0 ..< 8 {
                    if (row + col) % 2 == 0 {
                    ctx.cgContext.fill(CGRect(x: col * 64, y: row * 64, width: 64, height: 64))
                    }
                }
            }
        }

        imageView.image = img
    }

    func drawRotatedSquares() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

        let img = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)

            let rotations = 16
            let amount = Double.pi / Double(rotations)

            for _ in 0 ..< rotations {
                ctx.cgContext.rotate(by: CGFloat(amount))
                ctx.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))
            }

            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }

        imageView.image = img
    }
    
    func drawImageAndText() {
        //1. renderer size
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

        let img = renderer.image { ctx in
            
            //2. paragraph and text style
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            //3. add style into a attributes dictionary
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 48),
                .paragraphStyle: paragraphStyle
            ]
            
            //4. wrap dict and a string into an instance of NSAttributedString
            let string = "The best-laid schemes o'\nmice an' men gang aft agley"
            let attributedString = NSAttributedString(string: string, attributes: attrs)
            
            //5. load an image and draw into context
            let mouse = UIImage(named: "mouse")
            
            attributedString.draw(with: CGRect(x: 32, y: 32, width: 200, height: 600), options: .usesLineFragmentOrigin, context: nil)
            mouse?.draw(at: CGPoint(x: 300, y: 150))
        }
        //6. update imageview
        imageView.image = img
    }
    
    func drawStarEmoji() {
        let frameWidth = Double(512)
        let frameHeight = Double(512)
        
        let unitLengthConstant = Double(16)
        
        let unitInX = frameWidth / unitLengthConstant
        let unitInY = frameHeight / unitLengthConstant
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: frameWidth, height: frameHeight))
        
        let star = renderer.image { ctx in
            let pointA = CGPoint(x: 8 * unitInX, y: 3 * unitInY)
            let pointB = CGPoint(x: 6.4 * unitInX, y: 7 * unitInY)
            let pointC = CGPoint(x: 2 * unitInX, y: 7 * unitInY)
            let pointD = CGPoint(x: 5.8 * unitInX, y: 9 * unitInY)
            let pointE = CGPoint(x: 4 * unitInX, y: 13 * unitInY)
            let pointF = CGPoint(x: 8.2 * unitInX, y: 10.5 * unitInY)
            let pointG = CGPoint(x: 12 * unitInX, y: 13 * unitInY)
            let pointH = CGPoint(x: 10.4 * unitInX, y: 9 * unitInY)
            let pointI = CGPoint(x: 14 * unitInX, y: 7 * unitInY)
            let pointJ = CGPoint(x: 9.7 * unitInX, y: 7 * unitInY)
            
            ctx.stroke(renderer.format.bounds)
            ctx.cgContext.addLines(between: [pointA, pointB, pointC, pointD, pointE, pointF, pointG, pointH, pointI, pointJ, pointA])
            ctx.cgContext.setStrokeColor(UIColor.yellow.cgColor)
            ctx.cgContext.setFillColor(red: 255, green: 255, blue: 0, alpha: 1)
            ctx.cgContext.setLineWidth(5)
            
            ctx.cgContext.drawPath(using: .fillStroke)
        }

        imageView.image = star
    }
}

