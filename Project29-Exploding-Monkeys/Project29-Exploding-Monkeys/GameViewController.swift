//
//  GameViewController.swift
//  Project29-Exploding-Monkeys
//
//  Created by Gökhan on 30.10.2022.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    @IBOutlet var angleSlider: UISlider!
    @IBOutlet var angleLabel: UILabel!
    
    @IBOutlet var velocitySlider: UISlider!
    @IBOutlet var velocityLabel: UILabel!
    
    @IBOutlet var launchButton: UIButton!
    @IBOutlet var playerNumber: UILabel!
    
    @IBOutlet var player1Score: UILabel!
    @IBOutlet var player2Score: UILabel!

    @IBOutlet var windLabel: UILabel!
    
    var windVelocity = 0
    
    var scorePoint1 = 0 {
        didSet {
            player1Score.text = String(scorePoint1)
        }
    }
    var scorePoint2 = 0 {
        didSet {
            player2Score.text = String(scorePoint2)
        }
    }
    
    var currentGame: GameScene!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        player1Score.text = "0"
        player2Score.text = "0"
        windLabel.text = "no wind"
        
        angleChanged(angleSlider!)
        velocityChanged(velocitySlider!)
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
                currentGame = scene as? GameScene
                currentGame.viewController = self
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func angleChanged(_ sender: Any) {
        angleLabel.text = "Angle: \(Int(angleSlider.value))°"
    }
    
    @IBAction func velocityChanged(_ sender: Any) {
        velocityLabel.text = "Velocity: \(Int(velocitySlider.value))"
    }
    
    @IBAction func launch(_ sender: Any) {
        angleSlider.isHidden = true
        angleLabel.isHidden = true

        velocitySlider.isHidden = true
        velocityLabel.isHidden = true

        launchButton.isHidden = true

        currentGame.launch(angle: Int(angleSlider.value), velocity: Int(velocitySlider.value))
    }
    
    func activatePlayer(number: Int) {
        if number == 1 {
            playerNumber.text = "<<< PLAYER ONE"
        } else {
            playerNumber.text = "PLAYER TWO >>>"
        }

        angleSlider.isHidden = false
        angleLabel.isHidden = false

        velocitySlider.isHidden = false
        velocityLabel.isHidden = false

        launchButton.isHidden = false
    }
    
    func createWind(){
        windVelocity = Int.random(in: -150...150)
        if windVelocity == 0 {
            windVelocity = 1
        } else if windVelocity < 0 {
            windLabel.text = "<-- wind"
        }else {
            windLabel.text = "wind -->"
        }
    }
    
}
