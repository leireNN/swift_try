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
        let texture = SKTexture(imageNamed: "kirby")
        super.init(texture: texture, color: SKColor.clearColor(), size: CGSize(width: texture.size().width/6, height: texture.size().height/6))
        self.name = "invader"
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder:aDecoder)
    }
    
    func fireBullet(scene: SKScene){
        let bullet = InvaderBullet(imageName: "taser", bulletSound: nil)
        bullet.position.x = self.position.x
        bullet.position.y = self.position.y-self.size.height/2
        scene.addChild(bullet)
        let moveBulletAction = SKAction.moveTo(CGPoint(x: self.position.x, y: 0-bullet.size.height) , duration: 2.0)
        let removeBulletAction = SKAction.removeFromParent()
        bullet.runAction(SKAction.sequence([moveBulletAction, removeBulletAction]))
    }
}
