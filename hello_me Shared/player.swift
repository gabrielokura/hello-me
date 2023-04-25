//
//  player.swift
//  hello_me macOS
//
//  Created by Gabriel Motelevicz Okura on 07/03/23.
//
import SpriteKit

enum PlayerStatus {
    case walkingRight
    case walkingLeft
    case idle
}

class Player: SKSpriteNode, GameObject  {
    
    var playerStatus: PlayerStatus = .idle
    
    var walkAnimation: SKAction!
    var jumpAnimation: SKAction!
    
    let forceModule: Double = 400
    var isJumping: Bool = false
    
    let jumpSound = SKAction.playSoundFileNamed("jump.mp3", waitForCompletion: false)
    
     class func newPlayer() -> Player{
        
        let player = Player(imageNamed: "zombie_stand")
        
        player.position = CGPoint(x: 500, y: 160)
        player.zPosition = 6
        player.name = "player"
        
         player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody!.friction = 10
        player.physicsBody!.allowsRotation = false
        player.walkAnimation = setupWalkAnimation()
        player.jumpAnimation = setupJumpAnimation()
         
        return player
    }
    
    func animate() {
        self.run(walkAnimation)
    }
    
    func jump(){
        if isJumping {
            return
        }
        isJumping = true
        self.physicsBody!.velocity = CGVector(dx: 0, dy: 600)
    }
    
    
    func walk(dx: Double) {
        let dy = self.physicsBody!.velocity.dy
        self.physicsBody!.velocity = CGVector(dx: dx, dy: dy)
        
        if dx < 0 {
            self.xScale = -1
        } else {
            self.xScale = 1
        }
    }
    
    func idle() {
        
        if isJumping {
            return
        }
        
        let images = [
            SKTexture(imageNamed: "zombie_stand")
        ]
        let animation = SKAction.animate(with: images, timePerFrame: 1)
        self.run(animation)
        self.playerStatus = .idle
    }
    
    func resetJump() {
        isJumping = false
    }
    
    func handleKeyDownEvent(code: UInt16) {
        switch code {
        case 2:
            playerStatus = .walkingRight
            self.removeAllActions()
            self.run(walkAnimation)
        case 13: // pra cima W
            self.removeAllActions()
            self.run(jumpAnimation)
            self.run(jumpSound)
            jump()
        case 1:
            playerStatus = .idle
        case 0:
            playerStatus = .walkingLeft
            self.removeAllActions()
            self.run(walkAnimation)
            
        default:
            debugPrint("tecla não reconhecida")
        }
    }
    
    func handleKeyUpEvent(code: UInt16) {
        switch code {
        case 2, 13, 1, 0:
            playerStatus = .idle
            idle()
            
        default:
            debugPrint("tecla não reconhecida")
        }
    }
    
    func updateMovement() {
        
        switch playerStatus {
        case PlayerStatus.walkingRight:
            walk(dx: forceModule)
        case PlayerStatus.walkingLeft:
            walk(dx: -forceModule)
            
        default:
            idle()
        }
        
    }
    
}

func setupWalkAnimation() -> SKAction{
    let walkList = [SKTexture]([
        SKTexture(imageNamed: "zombie_walk1"),
        SKTexture(imageNamed: "zombie_walk2"),
    ])
    
    let walk = SKAction.animate(with: walkList, timePerFrame: 0.08, resize: true, restore: true)
    
    return SKAction.repeatForever(walk)
}

func setupJumpAnimation() -> SKAction {
    let texture = SKTexture(imageNamed: "zombie_jump")
    return SKAction.setTexture(texture)
}
