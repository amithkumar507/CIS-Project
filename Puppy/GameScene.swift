//
//  GameScene.swift
//  Puppy
//
//  Created by Amith Kumar Aellanki on 1/16/17.
//  Copyright © 2017 Amith Kumar Aellanki. All rights reserved.
//

import SpriteKit
class GameScene: SKScene {
    
    override init(size: CGSize) {
        let maxAspectRatio:CGFloat = 16.0/9.0 // 1
        let playableHeight = size.width / maxAspectRatio // 2
        let playableMargin = (size.height-playableHeight)/2.0 // 3
        playableRect = CGRect(x: 0, y: playableMargin,
                              width: size.width,
                              height: playableHeight) // 4
        super.init(size: size) // 5
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented") // 6
        
    }
    
    let puppy = SKSpriteNode(imageNamed: "pikachu")
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    let puppyMovePointsPerSec: CGFloat = 480.0
    var velocity = CGPoint.zero
    let playableRect: CGRect
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black
        let background = SKSpriteNode(imageNamed: "background1")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -1
        addChild(background)
        
        
        puppy.position = CGPoint(x: 400, y: 400)
        puppy.zPosition = 100
      
        addChild(puppy)
        
        debugDrawPlayableArea()
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
        print("\(dt*1000) milliseconds since last update")
       move(sprite: puppy, velocity: velocity)
        
        boundsCheckpuppy()
        
        rotate(sprite: puppy, direction: velocity)
        
    }
    
    
    func move(sprite: SKSpriteNode, velocity: CGPoint) {
        // 1
        let amountToMove = CGPoint(x: velocity.x * CGFloat(dt),
                                   y: velocity.y * CGFloat(dt))
        print("Amount to move: \(amountToMove)")
        // 2
        sprite.position = CGPoint(
            x: sprite.position.x + amountToMove.x,
            y: sprite.position.y + amountToMove.y)
    }
    
    func movepuppyToward(location: CGPoint) {
        let offset = CGPoint(x: location.x - puppy.position.x,
                             y: location.y - puppy.position.y)
        
        let length = sqrt(
            Double(offset.x * offset.x + offset.y * offset.y))
        let direction = CGPoint(x: offset.x / CGFloat(length),
                                y: offset.y / CGFloat(length))
        velocity = CGPoint(x: direction.x * puppyMovePointsPerSec,
                           y: direction.y * puppyMovePointsPerSec)
    }
    
    func sceneTouched(touchLocation:CGPoint) {
        movepuppyToward(location: touchLocation)
    }
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        sceneTouched(touchLocation: touchLocation)
    }
    override func touchesMoved(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        sceneTouched(touchLocation: touchLocation)
    }
    
    func boundsCheckpuppy() {
        let bottomLeft = CGPoint(x: 0, y: playableRect.minY)
        let topRight = CGPoint(x: size.width, y: playableRect.maxY)
        
        if puppy.position.x <= bottomLeft.x {
            puppy.position.x = bottomLeft.x
            velocity.x = -velocity.x
        }
        if puppy.position.x >= topRight.x {
            puppy.position.x = topRight.x
            velocity.x = -velocity.x
        }
        if puppy.position.y <= bottomLeft.y {
            puppy.position.y = bottomLeft.y
            velocity.y = -velocity.y
        }
        if puppy.position.y >= topRight.y {
            puppy.position.y = topRight.y
            velocity.y = -velocity.y
        }
    }
    
    func debugDrawPlayableArea() {
        let shape = SKShapeNode()
        let path = CGMutablePath()
        path.addRect(playableRect)
        shape.path = path
        shape.strokeColor = SKColor.red
        shape.lineWidth = 4.0
        addChild(shape)
    }
    
    func rotate(sprite: SKSpriteNode, direction: CGPoint) {
        sprite.zRotation = CGFloat(
            atan2(Double(direction.y), Double(direction.x)))
        
        }
}







