//
//  GameViewController.swift
//  FlappySample
//
//  Created by Dai Haneda on 2017/11/18.
//  Copyright © 2017年 Dai Haneda. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
      
      if let view = self.view as! SKView? {
        if let scene = SKScene(fileNamed: "GameScene") {
          scene.scaleMode = .aspectFill
          scene.size = view.frame.size
          
          // Present the scene
          view.presentScene(scene)
          
          view.ignoresSiblingOrder = true
          view.showsFPS = true
          view.showsNodeCount = true
        }
        
      }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
