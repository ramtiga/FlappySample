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
  static let Score : UInt32 = 0x1 << 4
}

class GameScene: SKScene, SKPhysicsContactDelegate {
  
  var Ground = SKSpriteNode()
  var Ghost = SKSpriteNode()
  var wallPair = SKNode()
  var moveAndRemove = SKAction()
  var gameStartFlag = Bool()
  var score = Int()
  var scoreLbl = SKLabelNode()
  var gameoverFlg = Bool()
  var restartBtn = SKSpriteNode()
  var highScore = 0
  var highScoreLbl = SKLabelNode()
  
  //シーン作成
  func createScene() {
    self.physicsWorld.contactDelegate = self
    
    //ハイスコア読み込み
    let userDefaults = UserDefaults.standard
    if userDefaults.object(forKey: "highScore") != nil {
      highScore = userDefaults.integer(forKey: "highScore")
    }
    //ハイスコア表示
    highScoreLbl.fontName = "04b_19"
    highScoreLbl.position = CGPoint(x: 0, y: -100)
    highScoreLbl.text = "High Score: \(highScore)"
    highScoreLbl.fontColor = UIColor.red
    highScoreLbl.fontSize = 48
    highScoreLbl.zPosition = 7
    highScoreLbl.name = "highScoreLbl"
    self.addChild(highScoreLbl)

    for i in 0..<2 {
      let background = SKSpriteNode(imageNamed: "background.png")
      background.anchorPoint = CGPoint.zero
      background.position = CGPoint(x: -self.frame.width / 2 + CGFloat(i) * self.frame.width, y: -self.frame.height / 2)
      background.name = "background"
      background.size = (self.view?.bounds.size)!
      self.addChild(background)
    }
    
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
    Ghost.physicsBody?.contactTestBitMask = PhysicsCategory.Ground | PhysicsCategory.Wall | PhysicsCategory.Score
    Ghost.physicsBody?.affectedByGravity = false
    Ghost.physicsBody?.isDynamic = true
    Ghost.zPosition = 2
    self.addChild(Ghost)
    
    scoreLbl.fontName = "04b_19"
    scoreLbl.position = CGPoint(x: 0, y: self.frame.height / 2.5)
    scoreLbl.text = "\(score)"
    scoreLbl.fontColor = UIColor.black
    scoreLbl.fontSize = 56
    scoreLbl.zPosition = 5
    self.addChild(scoreLbl)
  }
  
  //リスタートシーン
  func restartScene() {
    self.removeAllChildren()
    self.removeAllActions()
    gameoverFlg = false
    gameStartFlag = false
    Ghost.physicsBody?.affectedByGravity = true
    score = 0
    createScene()
  }
  
  override func didMove(to view: SKView) {
    createScene()
  }
  
  //壁作成
  func createWall() {
    wallPair = SKNode()
    wallPair.name = "wallPair"

    let scoreNode = SKSpriteNode(imageNamed: "coin.png")
    scoreNode.size = CGSize(width: 50, height: 50)
    scoreNode.position = CGPoint(x: self.frame.width / 2 - 15, y: 0)
    scoreNode.physicsBody = SKPhysicsBody(rectangleOf: scoreNode.size)
    scoreNode.physicsBody?.affectedByGravity = false
    scoreNode.physicsBody?.isDynamic = false
    scoreNode.physicsBody?.categoryBitMask = PhysicsCategory.Score
    scoreNode.physicsBody?.collisionBitMask = 0
    scoreNode.physicsBody?.contactTestBitMask = PhysicsCategory.Ghost
    scoreNode.color = UIColor.blue
    

    let topWall = SKSpriteNode(imageNamed: "wall.png")
    let btmWall = SKSpriteNode(imageNamed: "wall.png")
    
    topWall.position = CGPoint(x: self.frame.width / 2 - 15, y: 375)
    btmWall.position = CGPoint(x: self.frame.width / 2 - 15, y: -375)
    
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
    
    let randomPosition = CGFloat.random(min: -200, max: 200)
    wallPair.position.y += randomPosition
    wallPair.addChild(scoreNode)
    wallPair.run(moveAndRemove)
    self.addChild(wallPair)
  }

  //画面タッチ開始処理
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if gameStartFlag == false {
      highScoreLbl.removeFromParent()
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
      Ghost.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 50))
    }
    else if gameoverFlg {
      
    } else {
      Ghost.physicsBody?.velocity = CGVector.zero
      Ghost.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 50.0))
    }

    for touch in touches {
      let location = touch.location(in: self)
      if gameoverFlg {
        if restartBtn.contains(location) {
          restartScene()
        }
      }
    }
  }
  
  override func update(_ currentTime: TimeInterval) {
    // Called before each frame is rendered
    if gameStartFlag {
      if gameoverFlg == false {
        enumerateChildNodes(withName: "background", using: ({
          (node, error) in
          let bg = node as! SKSpriteNode
          bg.position = CGPoint(x: bg.position.x - 2, y: bg.position.y)
          if bg.position.x <= -bg.size.width - (bg.size.width / 2){
            bg.position = CGPoint(x: bg.position.x + bg.size.width * 2, y: bg.position.y)
          }
        }))
        
      }
      
    }
  }
  
  //衝突処理
  func didBegin(_ contact: SKPhysicsContact) {
    if contact.bodyA.categoryBitMask == PhysicsCategory.Ghost && contact.bodyB.categoryBitMask == PhysicsCategory.Score {
      score += 1
      scoreLbl.text = "\(score)"
      contact.bodyB.node?.removeFromParent()
    }
    else if contact.bodyB.categoryBitMask == PhysicsCategory.Ghost && contact.bodyA.categoryBitMask == PhysicsCategory.Score {
      score += 1
      scoreLbl.text = "\(score)"
      contact.bodyA.node?.removeFromParent()
    }
    if contact.bodyA.categoryBitMask == PhysicsCategory.Ghost && contact.bodyB.categoryBitMask == PhysicsCategory.Wall ||
       contact.bodyB.categoryBitMask == PhysicsCategory.Ghost && contact.bodyA.categoryBitMask == PhysicsCategory.Wall ||
       contact.bodyB.categoryBitMask == PhysicsCategory.Ghost && contact.bodyA.categoryBitMask == PhysicsCategory.Ground ||
       contact.bodyB.categoryBitMask == PhysicsCategory.Ghost && contact.bodyA.categoryBitMask == PhysicsCategory.Ground {
      enumerateChildNodes(withName: "wallPair", using: ({
        (node, error) in
        node.speed = 0
        self.removeAllActions()
      }))
      if gameoverFlg == false {
        gameoverFlg = true
        self.createBtn()
        updateHighScore()
      }
    }
  }
  
  //リスタートボタン作成
  func createBtn() {
    restartBtn = SKSpriteNode(imageNamed: "restart_btn")
    restartBtn.size = CGSize(width: 200, height: 100)
    restartBtn.position = CGPoint(x: 0, y: 0)
    restartBtn.zPosition = 6
    restartBtn.setScale(0)
    self.addChild(restartBtn)
    restartBtn.run(SKAction.scale(to: 1.0, duration: 0.3))
  }
  
  func updateHighScore() {
    if score > highScore {
      let userDefaults = UserDefaults.standard
      userDefaults.set(score, forKey: "highScore")

      highScoreLbl.position = CGPoint(x: 0, y: -100)
      highScoreLbl.text = "High Score!"
      highScoreLbl.fontColor = UIColor.red
      highScoreLbl.fontSize = 48
      highScoreLbl.zPosition = 7
      self.addChild(highScoreLbl)
    }
  }
}
