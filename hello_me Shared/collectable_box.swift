//
//  collectable_box.swift
//  hello_me macOS
//
//  Created by Gabriel Motelevicz Okura on 08/03/23.
//

import SpriteKit

class CollectableBox: SKSpriteNode, GameObject {
    
    func animate() {
        debugPrint("animating box")
    }
    
    class func newBox(isCollectable: Bool, position: CGPoint, name: String) -> CollectableBox {
        let imageName: String = isCollectable ? "yellow_box" : "grey_box"
        let box = CollectableBox(imageNamed: imageName)
        
        box.position = position
        box.setScale(0.8)
        box.zPosition = 6
        box.name = name
        
        box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
        box.physicsBody?.isDynamic = false
        box.physicsBody?.categoryBitMask = 1
        
        return box
    }
}
