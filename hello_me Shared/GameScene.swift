//
//  GameScene.swift
//  hello_me Shared
//
//  Created by Gabriel Motelevicz Okura on 06/03/23.
//

import SpriteKit
import AVFoundation


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    fileprivate var label : SKLabelNode?
    
    var gameObjects: [GameObject]?
    
    var player: Player?
    var gift: Gift?
    
    let word = ["B", "I", "E", "L"]
    var wordNode: SKLabelNode!
    var wordCount: Int = 0
    
    var timer: Timer!
    let completeSound = SKAction.playSoundFileNamed("success.wav", waitForCompletion: false)
    let progressSound = SKAction.playSoundFileNamed("find_letter.wav", waitForCompletion: false)
    let gameOverSound = SKAction.playSoundFileNamed("game_over.wav", waitForCompletion: false)
    
    class func newGameScene(gameObjects: [GameObject]) -> GameScene {
        // Load 'GameScene.sks' as an SKScene.
        
        let scene = GameScene(size: CGSize(width: 1346, height: 757))
        scene.gameObjects = gameObjects
        scene.player = gameObjects.first as? Player
        scene.gift = gameObjects[1] as? Gift
        
        
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        
        return scene
    }
    
    override func didMove(to view: SKView) {
        
        setupBackgroundAnimation()
        wordNode = SKLabelNode(text: "")
        wordNode.position = CGPoint(x: self.size.width / 2, y: self.size.height - 100)
        wordNode.zPosition = 10
        wordNode.fontColor = NSColor.black
        wordNode.fontSize = 100
        self.addChild(wordNode)
        
        let mainBox = setupBox(isCollectable: true, position: CGPoint(x: self.size.width / 2, y: self.size.height - 350))
        
        // first boxes
        
        for i in 2...5 {
            let x: Double = Double(i) * mainBox.size.width
            _ = setupBox(isCollectable: false, position: CGPoint(x: x, y: self.size.height / 2 - 100))
        }
        
        // mid up boxes
        
        for i in 8...12 {
            let x: Double = Double(i) * mainBox.size.width
            _ = setupBox(isCollectable: false, position: CGPoint(x: x, y: self.size.height - 350))
        }
        
        // last boxes
        
        for i in 18...22 {
            let x: Double = Double(i) * mainBox.size.width
            _ = setupBox(isCollectable: false, position: CGPoint(x: x, y: self.size.height / 2 - 100))
        }
        
        _ = setupBox(isCollectable: true, position: CGPoint(x: self.size.width / 2 + 300, y: self.size.height - 300))
        
        _ = setupBox(isCollectable: true, position: CGPoint(x: self.size.width / 2, y: self.size.height - 600))
        
        _ = setupBox(isCollectable: true, position: CGPoint(x: 200, y: self.size.height - 100))
        
        
        
        physicsWorld.contactDelegate = self
        
        for object in gameObjects! {
            self.addChild(object)
        }
        
        let ground = setupGround(posX: 0)
        let groundBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width * 2, height: ground.size.height))
        groundBody.categoryBitMask = 1
        groundBody.isDynamic = false
        ground.physicsBody = groundBody
        
        for i in 1...20 {
            let x: Double = Double(i) * ground.size.width
            _ = setupGround(posX: x)
        }
        
        ground.physicsBody!.categoryBitMask = 1
        gift!.physicsBody!.categoryBitMask = 2
        
        player!.physicsBody!.contactTestBitMask = ground.physicsBody!.categoryBitMask | gift!.physicsBody!.categoryBitMask
        
        player!.physicsBody!.collisionBitMask = ground.physicsBody!.categoryBitMask
        
    }
    
    func setupBox(isCollectable: Bool, position: CGPoint) -> CollectableBox {

        let box = CollectableBox.newBox(isCollectable: isCollectable, position: position, name: "box")
        
        if isCollectable {
            let floor = SKSpriteNode(imageNamed: "layer1")
            
            floor.size = CGSize(width: box.size.width / 2, height: 1)
            floor.zPosition = 5
            let floorBody = SKPhysicsBody(rectangleOf:  floor.size)
            floorBody.isDynamic = false
            floorBody.categoryBitMask = 1
            
            floor.position = CGPoint(x: box.position.x, y: box.position.y  + box.size.height / 2)
            floor.setScale(2)
            floor.name = "box_bottom"
        
            floor.physicsBody = floorBody
            
            self.addChild(floor)
        }
        
        self.addChild(box)
        return box
    }
    
    func setupGround(posX: Double) -> SKSpriteNode{
        let ground = SKSpriteNode(imageNamed: "ground")
        
        ground.position = CGPoint(x: posX, y: 20)
        ground.zPosition = 5
        
        ground.name = "ground"
        
        self.addChild(ground)
        return ground
    }
    
    func setupBackgroundAnimation() {
        setupLayer(1)
        setupLayer(2)
        setupLayer(3)
        setupLayer(4)
//        setupLayer(7)
    }
    
    
    func setupLayer(_ layer: Int) {
        let sprite1 = SKSpriteNode(imageNamed: "layer\(layer)")
        let sprite2 = SKSpriteNode(imageNamed: "layer\(layer)")
        
        sprite1.position.y = -50
        sprite2.position = CGPoint(x: sprite1.size.width, y: sprite1.position.y)
        
        let layerNode = SKNode()
        layerNode.addChild(sprite1)
        layerNode.addChild(sprite2)
        
        layerNode.zPosition = CGFloat(layer)
        
        layerNode.position = CGPoint(x: self.size.width  * 0.5, y: self.size.height * 0.5)
        
        let moveLeft = SKAction.moveBy(x: -sprite1.size.width, y: 0, duration: TimeInterval(3 * (10 - layer)))
        
        let moveBack = SKAction.moveBy(x: sprite1.size.width, y: 0, duration: 0)
        
        let sequence = SKAction.sequence([moveLeft, moveBack])
        
        let loop = SKAction.repeatForever(sequence)
        
        layerNode.run(loop)
        self.addChild(layerNode)
    
    }
    
    
    func getTheGift() {

        gift!.removeAllActions()

        gift!.removeFromParent()

        let label = SKLabelNode(text: "você foi de comes e bebes :(")
        label.fontName = "Bradley Hand"
        label.fontSize = 60
        label.alpha = 0
        label.position = CGPoint(x: 673, y: 600)
        label.zPosition = 10
        self.addChild(label)

        let labelFadeIn = SKAction.fadeIn(withDuration: 2)
        let labelFadeOut = SKAction.fadeOut(withDuration: 2)
        
        let sequence = SKAction.sequence([labelFadeIn, labelFadeOut])

        label.run(sequence)
        
        resetBigWord()
        run(gameOverSound)
        
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
       if contact.bodyA.node is Player {
           collision(playerNode: contact.bodyA.node!, otherNode: contact.bodyB.node!)
       } else if contact.bodyB.node is Player {
           collision(playerNode: contact.bodyB.node!, otherNode: contact.bodyA.node!)
       }
   }
    
    func collision(playerNode : SKNode, otherNode: SKNode) {

       if otherNode.name == nil {
           return
       }

        if otherNode.name! == "ground" || otherNode is CollectableBox || otherNode.name! == "box"{
            player!.resetJump()
       } else if otherNode.name! == "gift" {
           getTheGift()
       }
        else if otherNode.name! == "box_bottom" {
            otherNode.removeFromParent()
            updateBigWord()
        }
   }
    
    override func update(_ currentTime: TimeInterval) {
        player!.updateMovement()
    }
    
    override func keyDown(with event: NSEvent) {
        self.player!.handleKeyDownEvent(code: event.keyCode)
    }
    
    override func keyUp(with event: NSEvent) {
        self.player!.handleKeyUpEvent(code: event.keyCode)
    }
    
    func updateBigWord() {
        debugPrint("show one more letter of the big word")
        if wordCount >= 4 {
            return
        }
        
        wordNode.text = wordNode.text! + word[wordCount]
        wordNode.alpha = 1
        
        debugPrint(wordNode.text ?? "")
        wordCount += 1
        
        if wordCount < 4 {
            playNewLetterSound()
        } else {
            playCompleteSound()
        }
    }
    
    func resetBigWord() {
        wordCount = 0
        wordNode.text = ""
        wordNode.alpha = 0
    }
    
    func playCompleteSound() {
        run(completeSound)
    }
    
    func playNewLetterSound () {
        run(progressSound)
    }
    
    
}
