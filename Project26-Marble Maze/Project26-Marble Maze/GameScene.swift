//
//  GameScene.swift
//  Project26-Marble Maze
//
//  Created by Gökhan on 9.10.2022.
//

import CoreMotion
import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var motionManager: CMMotionManager!
    
    var player: SKSpriteNode!
    var startingPosition = CGPoint(x: 96, y: 672)
    
    var lastTouchPosition: CGPoint?
    
    var portalCollection = [SKSpriteNode]()
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var isGameOver = false
    var level = 1
    
    enum CollisionTypes: UInt32 {
        case player = 1
        case wall = 2
        case star = 4
        case vortex = 8
        case finish = 16
        case portal = 32
    }
    
    override func didMove(to view: SKView) {
        
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = .zero
        
        loadLevel(forLevel: "1")
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        guard isGameOver == false else { return }
        
        #if targetEnvironment(simulator)
            if let currentTouch = lastTouchPosition {
                let diff = CGPoint(x: currentTouch.x - player.position.x, y: currentTouch.y - player.position.y)
                physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
            }
        #else
            if let accelerometerData = motionManager.accelerometerData {
                physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -50, dy: accelerometerData.acceleration.x * 50)
            }
        #endif
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }

        if nodeA == player {
            playerCollided(with: nodeB)
        } else if nodeB == player {
            playerCollided(with: nodeA)
        }
        
    }
    
    func playerCollided(with node: SKNode) {
        
        if node.name == "vortex" {
            score -= 1
            playerChangesPosition(from: node.position, to: startingPosition)
        } else if node.name == "star" {
            node.removeFromParent()
            score += 1
        } else if node.name == "portal" {
            let randomIndex = Int.random(in: 0..<portalCollection.count)
            let randomPortal = portalCollection[randomIndex]
            let randomTeleportPosition = randomPortal.position
            playerChangesPosition(from: node.position, to: randomTeleportPosition)
            portalCollection.remove(at: randomIndex)
            randomPortal.removeFromParent()
            node.removeFromParent()
            
        } else if node.name == "finish" {
            self.removeAllChildren()
            loadLevel(forLevel: "2")
        }
        
    }
    
    func createPlayer(at position: CGPoint) {
        
        player = SKSpriteNode(imageNamed: "player")
        player.position = position
        player.zPosition = 1
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.linearDamping = 0.5

        player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player.physicsBody?.contactTestBitMask = CollisionTypes.star.rawValue | CollisionTypes.vortex.rawValue | CollisionTypes.finish.rawValue | CollisionTypes.portal.rawValue
        player.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
        addChild(player)
        
    }
    
    func playerChangesPosition(from position1: CGPoint,to position2: CGPoint) {
        player.physicsBody?.isDynamic = false
        isGameOver = true
        
        let move = SKAction.move(to: position1, duration: 0.25)
        let scale = SKAction.scale(to: 0.0001, duration: 0.1)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([move, scale, remove])
        
        player.run(sequence) { [weak self] in
                self?.createPlayer(at: position2)
                self?.isGameOver = false
        }
    }
    
    func loadLevel(forLevel level: String) {
        
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.zPosition = 3
        addChild(scoreLabel)
        
        guard let levelURL = Bundle.main.url(forResource: "level" + "\(level)", withExtension: "txt") else {
            fatalError("Could not find level1.txt in the app bundle.")
        }
        guard let levelString = try? String(contentsOf: levelURL) else {
            fatalError("Could not load level1.txt from the app bundle.")
        }

        let lines = levelString.components(separatedBy: "\n")

        for (row, line) in lines.reversed().enumerated() {
            for (column, letter) in line.enumerated() {
                
                let position = CGPoint(x: (64 * column) + 32, y: (64 * row) + 32)
                if letter == "x" { createObject(for: "block", at: position, withCollisionType: .wall) }
                else if letter == "v" { createObject(for: "vortex", at: position, withCollisionType: .vortex) }
                else if letter == "s" { createObject(for: "star", at: position, withCollisionType: .star) }
                else if letter == "p" { createObject(for: "portal", at: position, withCollisionType: .portal)}
                else if letter == "f" { createObject(for: "finish", at: position, withCollisionType: .finish) }
                else if letter == " " { // this is just an empty tile!
                } else { fatalError("Unknown level letter: \(letter)") }
                
            }
        }
        createPlayer(at: startingPosition)
        self.level += 1
    }
    
    func createObject(for objectName: String, at position: CGPoint, withCollisionType collisionType: CollisionTypes) {
        let node = SKSpriteNode(imageNamed: objectName)
        node.name = objectName
        node.position = position
        
        if objectName == "vortex" {
            node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
        }
        
        if objectName != "x" {
            node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
            node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
            node.physicsBody?.categoryBitMask = collisionType.rawValue
        } else {
            node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
            node.physicsBody?.categoryBitMask = collisionType.rawValue
        }
        node.physicsBody?.isDynamic = false

        if objectName == "portal" {
            portalCollection.append(node)
            node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
        }
        
        node.physicsBody?.collisionBitMask = 0
        addChild(node)
    }
    
}
