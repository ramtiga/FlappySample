//
//  GameScene.swift
//  FlappySample
//
//  Created by Dai Haneda on 2017/11/18.
//  Copyright © 2017年 Dai Haneda. All rights reserved.
//

import SpriteKit

struct PhysicsCategory {
  static let Ghost : UInt32 = 0x1 << 1
  static let Wall : UInt32 = 0x1 << 2
  static let Ground : UInt32 = 0x1 << 3
}

class GameScene: SKScene {
  
  var Ground = SKSpriteNode()
  var Ghost = SKSpriteNode()
  var wallPair = SKNode()
  var moveAndRemove = SKAction()
  var gameStartFlag = Bool()
    
  override func didMove(to view: SKView) {
    Ground = SKSpriteNode(imageNamed: "ground.png")
    //      Ground.setScale(0.5)
    Ground.position = CGPoint(x: 0, y: -self.frame.height / 2 + Ground.frame.height / 2)
    Ground.physicsBody = SKPhysicsBody(rectangleOf: Ground.size)
    Ground.physicsBody?.categoryBitMask = PhysicsCategory.Ground
    Ground.physicsBody?.collisionBitMask = PhysicsCategory.Ghost
    Ground.physicsBody?.contactTestBitMask = PhysicsCategory.Ghost
    Ground.physicsBody?.affectedByGravity = false
    Ground.physicsBody?.isDynamic = false
    Ground.zPosition = 3
    
    self.addChild(Ground)
    
    Ghost = SKSpriteNode(imageNamed: "ghost.png")
    Ghost.size = CGSize(width: 50, height: 60)
    Ghost.position = CGPoint(x: -Ghost.frame.width, y: 0)
    
    Ghost.physicsBody = SKPhysicsBody(circleOfRadius: Ghost.frame.height / 2)
    Ghost.physicsBody?.categoryBitMask = PhysicsCategory.Ghost
    Ghost.physicsBody?.collisionBitMask = PhysicsCategory.Ground | PhysicsCategory.Wall
    Ghost.physicsBody?.contactTestBitMask = PhysicsCategory.Ground | PhysicsCategory.Wall
    Ghost.physicsBody?.affectedByGravity = false
    Ghost.physicsBody?.isDynamic = true
    Ghost.zPosition = 2
    self.addChild(Ghost)
  }
  
  //壁作成
  func createWall() {
    wallPair = SKNode()
    
    let topWall = SKSpriteNode(imageNamed: "wall.png")
    let btmWall = SKSpriteNode(imageNamed: "wall.png")
    
//    topWall.setScale(0.5)
//    btmWall.setScale(0.5)
    
    topWall.position = CGPoint(x: self.frame.width / 2 - 15, y: 350)
    btmWall.position = CGPoint(x: self.frame.width / 2 - 15, y: -350)
    
    topWall.physicsBody = SKPhysicsBody(rectangleOf: topWall.size)
    topWall.physicsBody?.categoryBitMask = PhysicsCategory.Wall
    topWall.physicsBody?.collisionBitMask = PhysicsCategory.Ghost
    topWall.physicsBody?.contactTestBitMask = PhysicsCategory.Ghost
    topWall.physicsBody?.affectedByGravity = false
    topWall.physicsBody?.isDynamic = false
    
    btmWall.physicsBody = SKPhysicsBody(rectangleOf: btmWall.size)
    btmWall.physicsBody?.categoryBitMask = PhysicsCategory.Wall
    btmWall.physicsBody?.collisionBitMask = PhysicsCategory.Ghost
    btmWall.physicsBody?.contactTestBitMask = PhysicsCategory.Ghost
    btmWall.physicsBody?.affectedByGravity = false
    btmWall.physicsBody?.isDynamic = false

    wallPair.addChild(topWall)
    wallPair.addChild(btmWall)

    wallPair.zPosition = 1
    
    var randomPosition = CGFloat.random(min: -200, max: 200)
    print(randomPosition)
    wallPair.position.y += randomPosition
    wallPair.run(moveAndRemove)
    self.addChild(wallPair)
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if gameStartFlag == false {
      gameStartFlag = true
      Ghost.physicsBody?.affectedByGravity = true
      
      let spawn = SKAction.run({ () in
        self.createWall()
      })
      let delay = SKAction.wait(forDuration: 2.0)
      let spawDelay = SKAction.sequence([spawn, delay])
      let spawnDelayForever = SKAction.repeatForever(spawDelay)
      self.run(spawnDelayForever)

      let distance = CGFloat(self.frame.width + wallPair.frame.width)
      let movePipes = SKAction.moveBy(x: -distance, y: 0, duration: TimeInterval(0.008 * distance))
      let removePipes = SKAction.removeFromParent()
      moveAndRemove = SKAction.sequence([movePipes, removePipes])

      Ghost.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
      Ghost.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 90))
    }
    Ghost.physicsBody?.velocity = CGVector.zero
    Ghost.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 60.0))
  }
  
  override func update(_ currentTime: TimeInterval) {
    // Called before each frame is rendered
  }
}
