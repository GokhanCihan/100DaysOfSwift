//
//  GameScene.swift
//  milestone-Space Shooter
//
//  Created by Gökhan on 1.09.2022.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var player: SKSpriteNode!
    var playerSelected = false {
        didSet {
            print(playerSelected)
        }
    }
    let hightech = ["hightech-1", "hightech-2", "hightech-3"]
    let steampunk = ["steampunk-1", "steampunk-2", "steampunk-3"]
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        let background = SKSpriteNode(imageNamed: "background")
        background.name = "background"
        background.position = CGPoint(x: 512, y: 384)
        background.zPosition = -1
        background.blendMode = .replace
        addChild(background)
        
        player = SKSpriteNode(imageNamed: "good")
        player.name = "player"
        player.size = CGSize(width: 75, height: 100)
        player.position = CGPoint(x: 512, y: 60)
        addChild(player)
        
        createTarget(for: 5)
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
    
    func createTarget(for targets: Int) {
        
        //should create 3 rows of targets
            //different kind of target in each row
        //targets should move
            //opposite directions for each row
            //different speeds for each row
            //rows should change direction
        
        for target in 0...targets {
            let ship = SKSpriteNode(imageNamed: hightech.randomElement()!)
            ship.name = "hightech"
            
            //modify equations for x and y positions
            ship.position = CGPoint(x: 200 + (624 / (targets + 1) + (100 / 5)) * target, y: 384)
            ship.size = CGSize(width: 60, height: 40)
            addChild(ship)
            
            ship.physicsBody = SKPhysicsBody(texture: ship.texture!, size: ship.size)
            ship.physicsBody?.contactTestBitMask = 1
            
            ship.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
        
    }

    //player should fire projectiles
        //when projectiles come to contact with targets
            //destroy target
            //destroy projectile
            //get points or lose
    
}
