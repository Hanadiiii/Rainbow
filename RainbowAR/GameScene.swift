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
    
    var game = GameViewController()
    
    var playerNode = Player()
    var pointNode = Point()
    var playButton: SKShapeNode!
    var currentScoreLabel: SKLabelNode!
    var faceNotVisibleLabel: SKLabelNode!
    var playerIsMoving: Bool = false
    var currentScore = 0
    
    var generator: UIImpactFeedbackGenerator!
    
    let pointPositionArray: [CGFloat] = [300, 200, 100, 0, -100, -200, -300]
    
    override func didMove(to view: SKView) { //This function runs as soon as view is presented by GameViewController viewDidLoad (basically this is a viewDidLoad for the GameScene)
        
        playerNode = self.childNode(withName: "player") as! Player
        pointNode = self.childNode(withName: "point") as! Point
        
        currentScoreLabel = self.childNode(withName: "currentScore") as? SKLabelNode
        currentScoreLabel.text = "\(currentScore)"
        //        currentScoreLabel.isHidden = true
        
        faceNotVisibleLabel = self.childNode(withName: "faceNotVisible") as? SKLabelNode
        faceNotVisibleLabel.isHidden = true
        
        playerNode.position = CGPoint(x: 0, y: 0) //sets default position of the player to center of view
        
        updatePoint()
        
        generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        
        /* //This code creates a play button, but this button doesn't do anything yet
         playButton = SKShapeNode()
         playButton.name = "play_button"
         playButton.zPosition = 1
         playButton.position = CGPoint(x: 0, y: 0)
         playButton.fillColor = SKColor.black
         let topCorner = CGPoint(x: -50, y: 50)
         let bottomCorner = CGPoint(x: -50, y: -50)
         let middle = CGPoint(x: 50, y: 0)
         let path = CGMutablePath()
         path.addLine(to: topCorner)
         path.addLines(between: [topCorner, bottomCorner, middle])
         playButton.path = path
         self.addChild(playButton)
         */
    }
    
    // MARK: - Player Movement Functions
    
    func updatePlayer (state: PlayerState) { //updatePlayer is called when eyebrows move. If the player is not already moving, this function calls movePlayer
        if !playerIsMoving {
            movePlayer(state: state)
        }
    }
    
    func movePlayer (state: PlayerState) { //This function is responsible for moving the player up, down, or keeping it neutral
        
        playerNode.texture = SKTexture(imageNamed: state.rawValue)
        var vibrate: Bool = false
        var direction: Int = 0
        
        switch state {
        case .up:
            direction = 100
            vibrate = true
        case .down:
            direction = -100
            vibrate = true
        case .neutral:
            direction = 0
            vibrate = false
        }
        
        if Int(playerNode.position.y) + Int(direction) >= -332 && Int(playerNode.position.y) + Int(direction) <= 332 {
            playerIsMoving = true
            
            let moveAction = SKAction.moveBy(x: 0, y: CGFloat(direction), duration: 0.3)
            
            let moveEndedAction = SKAction.run {
                self.playerIsMoving = false
                if vibrate {
                    self.generator.impactOccurred()
                }
                self.checkForScore()
            }
            
            let moveSequence = SKAction.sequence([moveAction, moveEndedAction])
            
            playerNode.run(moveSequence)
            
            print("😀 Player: \(playerNode.position.y)")
        }
    }
    
    // MARK: - Point movement functions
    
    func updatePoint(state: PointImage = PointImage.random()) { //this function will be called after the player has touched the current point
        guard let newRandomPointPositionY = pointPositionArray.randomElement() else { return } //randomizes point position
        let newRandomPointTexture = SKTexture(imageNamed: PointImage.random().rawValue)
        let currentPlayerPositionY = playerNode.position.y
        
        if newRandomPointPositionY == currentPlayerPositionY {
            updatePoint()
        } else {
            pointNode.texture = newRandomPointTexture // randomized emoji for pointNode
            pointNode.position = CGPoint(x: 0, y: newRandomPointPositionY) // new random point position
            print("🌟 Point: \(pointNode.position.y)")
        }
    }
    
    func checkForScore() {
        let currentPlayerPositionY = playerNode.position.y
        let currentPointPositionY = pointNode.position.y
        
        if currentPlayerPositionY <= currentPointPositionY + 1 && currentPlayerPositionY >= currentPointPositionY - 1 {
            currentScore += 1
            currentScoreLabel.text = "\(currentScore)"
            updatePoint()
        }
    }
}
