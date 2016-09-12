//
//  Invader.swift
//  spaceWar
//
//  Created by Leire Polo on 7/9/16.
//  Copyright © 2016 Leire Polo. All rights reserved.
//

import UIKit
import SpriteKit

class Invader: SKSpriteNode {

    var invaderRow = 0
    var invaderColumn = 0
    
    init(){
        let texture = SKTexture(imageNamed: "salad")
        super.init(texture: texture, color: SKColor.clearColor(), size: CGSize(width: texture.size().width/4, height: texture.size().height/4))
        self.name = "invader"
        
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.dynamic = true
        self.physicsBody?.usesPreciseCollisionDetection = false
        self.physicsBody?.categoryBitMask = CollisionCategories.Invader
        self.physicsBody?.contactTestBitMask = CollisionCategories.PlayerBullet | CollisionCategories.Player
        self.physicsBody?.collisionBitMask = 0x0
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder:aDecoder)
    }
    
    func fireBullet(scene: SKScene){
        let bullet = InvaderBullet(imageName: "salad", bulletSound: nil)
        bullet.setScale(0.25)
        bullet.position.x = self.position.x
        bullet.position.y = self.position.y-self.size.height/2
        scene.addChild(bullet)
        let moveBulletAction = SKAction.moveTo(CGPoint(x: self.position.x, y: 0-bullet.size.height) , duration: 2.0)
        let removeBulletAction = SKAction.removeFromParent()
        bullet.runAction(SKAction.sequence([moveBulletAction, removeBulletAction]))
    }
}
