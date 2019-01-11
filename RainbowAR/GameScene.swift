//
//  GameScene.swift
//  RainbowAR
//
//  Created by Steve Lederer on 1/10/19.
//  Copyright © 2019 Steve Lederer. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var playerNode: Player?
    var pointNode: Point?
    var moving: Bool = false
    
    var generator: UIImpactFeedbackGenerator!
    
    var scorePosition: CGPoint?
    
    override func didMove(to view: SKView) {
        playerNode = self.childNode(withName: "player") as? Player
        pointNode = self.childNode(withName: "point") as? Point
        
        generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
    }
    
    func updatePlayer (state: PlayerState) {
        if !moving {
            movePlayer(state: state)
        }
    }
    
    func movePlayer (state: PlayerState) {
        if let player = playerNode {
            player.texture = SKTexture(imageNamed: state.rawValue)
            
            
            var direction: CGFloat = 0
            
            switch state {
            case .up:
                direction = 100
            case .down:
                direction = -100
            case .neutral:
                direction = 0
            }
            
            if Int(player.position.y) + Int(direction) >= -332 && Int(player.position.y) + Int(direction) <= 332 {
                moving = true
                
                let moveAction = SKAction.moveBy(x: 0, y: direction, duration: 0.3)
                
                let moveEndedAction = SKAction.run {
                    self.moving = false
                    if direction != 0 {
                        self.generator.impactOccurred()
                    }
                }
                
                let moveSequence = SKAction.sequence([moveAction, moveEndedAction])
                
                player.run(moveSequence)
            }
        }
        
    }
    
//    override func update(_ currentTime: TimeInterval) {
//        // Called before each frame is rendered
//    }
    
    func updatePoint(state: pointState) {
        
    }
    
    func movePoint(state: pointState) {
        
    }
}
