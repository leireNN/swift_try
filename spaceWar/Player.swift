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
    
    fileprivate var canFire = true
    fileprivate var invincible = false
    fileprivate var angle = CGFloat(70)
    
    fileprivate var lives:Int = 3 {
        didSet {
            if(lives < 0){
                kill()
            }else{
                respawn()
            }
        }
    }
    
    init(){
        let texture = SKTexture(imageNamed: "sumo")
        super.init(texture: texture, color: SKColor.clear, size: CGSize(width: texture.size().width/4, height: texture.size().height/4))
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.usesPreciseCollisionDetection = false
        self.physicsBody?.categoryBitMask = CollisionCategories.Player
        self.physicsBody?.contactTestBitMask = CollisionCategories.InvaderBullet | CollisionCategories.Invader
        self.physicsBody?.collisionBitMask = CollisionCategories.EdgeBody
        self.physicsBody?.allowsRotation = false
        self.setScale(4)
        //animate()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func animate(){
        var playerTextures:[SKTexture] = []
        for i in 1...2{
            playerTextures.append(SKTexture(imageNamed: "sumo"))
        }
        let playerAnimation = SKAction.repeatForever(SKAction.animate(with: playerTextures, timePerFrame: 0.1))
        self.run(playerAnimation)
    }
    
    func die(){
        if(invincible == false){
            lives -= 1
        }
    }
    
    func kill(){
        invaderNum = 1
        let gameOverScene = StartGameScene(size: self.scene!.size)
        gameOverScene.scaleMode = self.scene!.scaleMode
        let transitionType = SKTransition.flipHorizontal(withDuration: 0.5)
        self.scene!.view!.presentScene(gameOverScene, transition: transitionType)
    }
    
    func respawn(){
        invincible = true
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.4)
        let fadeInAction = SKAction.fadeIn(withDuration: 0.4)
        let fadeOutIn = SKAction.sequence([fadeOutAction, fadeInAction])
        let fadeOutInAction = SKAction.repeat(fadeOutIn, count: 5)
        let setInvincibleFalse = SKAction.run(){
            self.invincible = false
        }
        run(SKAction.sequence([fadeOutInAction, setInvincibleFalse]))

    }
    
    func rotateRight(){
        let angle : CGFloat = -CGFloat(M_PI_4)
        let rotate = SKAction.rotate(byAngle: angle, duration: 0.25)
        run(rotate, withKey: "rotate")
        print("Rotation: \( self.zRotation)")
        self.angle += angle
        print("Angle: \( self.angle)")
    }
    
    func rotateLeft(){
        let angle : CGFloat = CGFloat(M_PI_4)
        let rotate = SKAction.rotate(byAngle: angle, duration: 0.25)
        run(rotate, withKey: "rotate")
        print("Rotation: \( self.zRotation)")
        self.angle += angle
        print("Angle: \( self.angle)")

    }
    
    func fireBullet(_ scene:SKScene, accelerationX: CGFloat, accelerationY: CGFloat){
        if(!canFire){
            return
        }else{
            canFire = false
            let bullet = PlayerBullet(imageName: "maki.png", bulletSound: nil)
            bullet.setScale(0.25)
            bullet.position.x = self.position.x
            bullet.position.y = self.position.y
            let rotate = SKAction.rotate(byAngle: self.zRotation, duration: 0.01)
            bullet.run(rotate)
            scene.addChild(bullet)
            //let moveBulletAction = SKAction.moveTo(CGPoint(x: self.position.x, y: scene.size.height+bullet.size.height), duration: 1.0)
            let moveActionVector = SKAction.move(by: CGVector(dx: cos((self.zRotation + (90.0 * 3.14/180.0))) * 5400, dy: sin((self.zRotation) + (90.0 * 3.14/180.0)) * 5400), duration: 3)
            
            let removeBulletAction = SKAction.removeFromParent()
            bullet.run(SKAction.sequence([moveActionVector, removeBulletAction]))
            let waitToEnableFire = SKAction.wait(forDuration: 0.5)
            run(waitToEnableFire, completion: {
                self.canFire = true
            })
        }
    }

}
