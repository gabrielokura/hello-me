//
//  GameViewController.swift
//  hello_me macOS
//
//  Created by Gabriel Motelevicz Okura on 06/03/23.
//

import Cocoa
import SpriteKit
import GameplayKit

class GameViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let objects = [Player.newPlayer() as GameObject, Gift.newGift() as GameObject]
        let scene = GameScene.newGameScene(gameObjects: objects)
        
        // Present the scene
        let skView = self.view as! SKView
        skView.presentScene(scene)
        
        skView.ignoresSiblingOrder = true
        
        skView.showsFPS = true
        skView.showsNodeCount = true
    }

}

