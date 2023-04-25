//
//  gift.swift
//  hello_me macOS
//
//  Created by Gabriel Motelevicz Okura on 07/03/23.
//

import SpriteKit

class Gift: SKSpriteNode, GameObject {

    var animation: SKAction!
    
    class func newGift() -> Gift {
        debugPrint("call gift init")
        
        let gift = Gift(imageNamed: "gift")
        gift.name = "gift"
        gift.setScale(0.2)
        gift.zPosition = 6
        
        gift.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
        gift.physicsBody!.isDynamic = false
        
        gift.animation = setupAnimation()
        gift.animate()
        return gift
    }
    
    func animate() {
        debugPrint("call gift animate")
        self.position = CGPoint(x: 2000, y: 500)
        self.run(animation)
    }
    
    
}

func setupAnimation() -> SKAction {
    let giftDown = SKAction.moveBy(x: 0, y: -300, duration: 2)
    let giftUp = SKAction.moveBy(x: 0, y: 300, duration: 2)

    giftDown.timingMode = .easeInEaseOut
    giftUp.timingMode = .easeInEaseOut


    let giftDownUp = SKAction.sequence([giftDown, giftUp])
    let giftDownUpForever = SKAction.repeatForever(giftDownUp)

    let giftMoveLeft = SKAction.moveBy(x: -2100, y: 0, duration: 14)
    let giftMoveRight = SKAction.moveBy(x: 2100, y: 0, duration: 0)
    let giftLeftRight = SKAction.sequence([giftMoveLeft, giftMoveRight])

    let giftLoop = SKAction.repeatForever(giftLeftRight)

    return SKAction.group([giftDownUpForever, giftLoop])
}
