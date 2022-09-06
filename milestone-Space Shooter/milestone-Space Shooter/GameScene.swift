//
//  GameScene.swift
//  milestone-Space Shooter
//
//  Created by Gökhan on 1.09.2022.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var gameTimer: Timer?
    var player: SKSpriteNode!
    var playerSelected = false

    let ships = ["hightech-1", "hightech-2", "hightech-3", "steampunk-1", "steampunk-2", "steampunk-3"]
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.name = "background"
        background.size = CGSize(width: 1366, height: 1024)
        background.position = CGPoint(x: 683, y: 512)
        background.zPosition = -1
        background.blendMode = .replace
        addChild(background)
        
        player = SKSpriteNode(imageNamed: "good")
        player.name = "player"
        player.size = CGSize(width: 75, height: 125)
        player.position = CGPoint(x: 683, y: 60)
        addChild(player)
        
        createTargets()
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchedNodes = nodes(at: touch.location(in: self))
        
        for node in touchedNodes {
            print(node.name!)
            if node.name == "player" {
                playerSelected = true
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if playerSelected {
            guard let touch = touches.first else { return }
            var location = touch.location(in: self)
            if location.y > 60 {
                location.y = 60
            } else if location.y < 60 {
                location.y = 60
            }
            player.position = location
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        playerSelected = false
    }
    
    func createTargets() {
        //targets should move
            //rows should change direction
        let screenWidth = UIScreen.main.bounds.width
        let rowsDistanceFromEdge = Int((screenWidth * 0.15).rounded())
        var velocity: Int
        var velocityDirection = 1

        for row in 0..<3 {
            let numberOfTargets = Int.random(in: 5...7)
            let distanceBetweenTargets = (Int(screenWidth) - 2 * rowsDistanceFromEdge) / (numberOfTargets - 1)
            velocityDirection *= -1
            velocity = Int.random(in: 25...90)
            
            for target in 0..<numberOfTargets {
                let ship = SKSpriteNode(imageNamed: ships.randomElement()!)
                ship.name = "hightech"
                            
                ship.position = CGPoint(x: rowsDistanceFromEdge + (target) * distanceBetweenTargets, y: (row * 150) + 486)
                ship.size = CGSize(width: 90, height: 60)
                addChild(ship)
                  
                ship.physicsBody = SKPhysicsBody(texture: ship.texture!, size: ship.size)
                ship.physicsBody?.velocity = CGVector(dx: velocity * velocityDirection, dy: 0)
                ship.physicsBody?.linearDamping = 0
            }
        }
        
    }

    //player should fire projectiles
        //when projectiles come to contact with targets
            //destroy target
            //destroy projectile
            //get points or lose
    //set timer
}
