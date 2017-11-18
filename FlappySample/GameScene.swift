//
//  GameScene.swift
//  FlappySample
//
//  Created by Dai Haneda on 2017/11/18.
//  Copyright © 2017年 Dai Haneda. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
  
  var Ground = SKSpriteNode()
  var Ghost = SKSpriteNode()
    
  override func didMove(to view: SKView) {
    Ground = SKSpriteNode(imageNamed: "ground.png")
    //      Ground.setScale(0.5)
    Ground.position = CGPoint(x: 0, y: -self.frame.height / 2 + Ground.frame.height / 2)
    self.addChild(Ground)
    
    Ghost = SKSpriteNode(imageNamed: "ghost.png")
    Ghost.size = CGSize(width: 50, height: 60)
    Ghost.position = CGPoint(x: -Ghost.frame.width, y: 0)
    self.addChild(Ghost)
    
    createWall()
  }
  
  func createWall() {
    let wallPair = SKNode()
    
    let topWall = SKSpriteNode(imageNamed: "wall.png")
    let btmWall = SKSpriteNode(imageNamed: "wall.png")
    
    topWall.setScale(0.5)
    btmWall.setScale(0.5)
    
    topWall.position = CGPoint(x: 0, y: 225)
    btmWall.position = CGPoint(x: 0, y: -225)
    
    wallPair.addChild(topWall)
    wallPair.addChild(btmWall)
    
    self.addChild(wallPair)
  }


  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
  }
  
  
  override func update(_ currentTime: TimeInterval) {
    // Called before each frame is rendered
  }
}
