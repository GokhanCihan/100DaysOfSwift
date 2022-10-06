//
//  ViewController.swift
//  Project15
//
//  Created by Gökhan on 6.08.2022.
//

import UIKit

extension UIView {
    func bounceOut(withDuration: Double) {
        UIView.animate(withDuration: withDuration, delay: 2, options: [],
                       animations: {
            self.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        }
        )
    }
}

class ViewController: UIViewController {
    var imageView: UIImageView!
    var currentAnimation = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        imageView = UIImageView(image: UIImage(named: "penguin"))
        imageView.center = CGPoint(x: 658, y: 514)
        view.addSubview(imageView)
    }

    @IBAction func Tapped(_ sender: UIButton) {
        sender.isHidden = true
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [],
                       animations: {
            switch self.currentAnimation {
            case 0:
                self.imageView.transform = CGAffineTransform(scaleX: 2, y: 2)
                
            case 1:
                self.imageView.transform = .identity
                
            case 2:
                self.imageView.transform = CGAffineTransform(translationX: -256, y: -256)
                
            case 3:
                self.imageView.transform = .identity
                
            case 4:
                self.imageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                
            case 5:
                self.imageView.transform = .identity
                
            case 6:
                self.imageView.alpha = 0.1
                self.imageView.backgroundColor = UIColor.green
                
            case 7:
                self.imageView.alpha = 1
                self.imageView.backgroundColor = UIColor.clear
                self.imageView.transform = .identity
            default:
                break
            }
        }) { finished in
            sender.isHidden = false
            if self.currentAnimation == 8 {
                self.imageView.bounceOut(withDuration: 10)
                
            }
            
        }
        
        currentAnimation += 1
        
        if currentAnimation > 8 {
            currentAnimation = 0
        }
        
    }
    
    
}

