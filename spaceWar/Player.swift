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
    
    private var canFire = true
    private var invincible = false
    private var angle = CGFloat(70)
    
    private var lives:Int = 3 {
        didSet {
            if(lives < 0){
                kill()
            }else{
                respawn()
            }
        }
    }
    
    init(){
        let texture = SKTexture(imageNamed: "spaceship")
        super.init(texture: texture, color: SKColor.clearColor(), size: CGSize(width: texture.size().width/4, height: texture.size().height/4))
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.dynamic = true
        self.physicsBody?.usesPreciseCollisionDetection = false
        self.physicsBody?.categoryBitMask = CollisionCategories.Player
        self.physicsBody?.contactTestBitMask = CollisionCategories.InvaderBullet | CollisionCategories.Invader
        self.physicsBody?.collisionBitMask = CollisionCategories.EdgeBody
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.collisionBitMask = 0x0
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
        if(invincible == false){
            lives -= 1
        }
    }
    
    func kill(){
        invaderNum = 1
        let gameOverScene = StartGameScene(size: self.scene!.size)
        gameOverScene.scaleMode = self.scene!.scaleMode
        let transitionType = SKTransition.flipHorizontalWithDuration(0.5)
        self.scene!.view!.presentScene(gameOverScene, transition: transitionType)
    }
    
    func respawn(){
        invincible = true
        let fadeOutAction = SKAction.fadeOutWithDuration(0.4)
        let fadeInAction = SKAction.fadeInWithDuration(0.4)
        let fadeOutIn = SKAction.sequence([fadeOutAction, fadeInAction])
        let fadeOutInAction = SKAction.repeatAction(fadeOutIn, count: 5)
        let setInvincibleFalse = SKAction.runBlock(){
            self.invincible = false
        }
        runAction(SKAction.sequence([fadeOutInAction, setInvincibleFalse]))

    }
    
    func rotateRight(){
        let angle : CGFloat = -CGFloat(M_PI_4)
        let rotate = SKAction.rotateByAngle(angle, duration: 0.25)
        runAction(rotate, withKey: "rotate")
        print("Rotation: \( self.zRotation)")
        self.angle += angle
        print("Angle: \( self.angle)")
    }
    
    func rotateLeft(){
        let angle : CGFloat = CGFloat(M_PI_4)
        let rotate = SKAction.rotateByAngle(angle, duration: 0.25)
        runAction(rotate, withKey: "rotate")
        print("Rotation: \( self.zRotation)")
        self.angle += angle
        print("Angle: \( self.angle)")

    }
    
    func fireBullet(scene:SKScene, accelerationX: CGFloat, accelerationY: CGFloat){
        if(!canFire){
            return
        }else{
            canFire = false
            let bullet = PlayerBullet(imageName: "taser", bulletSound: nil)
            bullet.position.x = self.position.x
            bullet.position.y = self.position.y+self.size.height/2
            scene.addChild(bullet)
            //let moveBulletAction = SKAction.moveTo(CGPoint(x: self.position.x, y: scene.size.height+bullet.size.height), duration: 1.0)
            let moveActionVector = SKAction.moveBy(CGVector(dx: cos((self.zRotation + (90.0 * 3.14/180.0))) * 5400, dy: sin((self.zRotation) + (90.0 * 3.14/180.0)) * 5400), duration: 3)
            
            let removeBulletAction = SKAction.removeFromParent()
            bullet.runAction(SKAction.sequence([moveActionVector, removeBulletAction]))
            let waitToEnableFire = SKAction.waitForDuration(0.5)
            runAction(waitToEnableFire, completion: {
                self.canFire = true
            })
        }
    }

}
