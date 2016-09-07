//
//  Player.swift
//  spaceWar
//
//  Created by Leire Polo on 7/9/16.
//  Copyright © 2016 Leire Polo. All rights reserved.
//

import UIKit
import SpriteKit

class Player: SKSpriteNode {
    
    init(){
        let texture = SKTexture(imageNamed: "spaceship")
        super.init(texture: texture, color: SKColor.clearColor(), size: CGSize(width: texture.size().width/4, height: texture.size().height/4))
        animate()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func animate(){
        var playerTextures:[SKTexture] = []
        for i in 1...2{
            playerTextures.append(SKTexture(imageNamed: "player\(i)"))
        }
        let playerAnimation = SKAction.repeatActionForever(SKAction.animateWithTextures(playerTextures, timePerFrame: 0.1))
        self.runAction(playerAnimation)
    }
    
    func die(){
        
    }
    
    func kill(){
        
    }
    
    func respawn(){
        
    }
    
    func fireBullet(scene:SKScene){
        
    }

}
