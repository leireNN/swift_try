//
//  GameScene.swift
//  spaceWar
//
//  Created by Leire Polo on 7/9/16.
//  Copyright (c) 2016 Leire Polo. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let rowsOfInvaders = 4
    var invaderSpeed = 2
    let leftBounds = CGFloat(30)
    var rigthBounds = CGFloat(0)
    var invadersWhoCanFire:[Invader] = [Invader]()
    let player:Player = Player()
    
    override func didMoveToView(view: SKView) {
        backgroundColor = SKColor.blackColor()
        rigthBounds = self.size.width-30
        NSLog("We have loaded the start screen")
        setupInvaders()
        setupPlayer()
        invokeInvaderFire()
    }
    
    func setupInvaders(){
        var invaderRow = 0
        var invaderColumn = 0
        let numberOfInvaders = invaderNum*2+1
        
        for var i = 1; i <= rowsOfInvaders; i += 1 {
            invaderRow = i
            for var j = 1; j <= numberOfInvaders; j += 1 {
                invaderColumn = j
                let tempInvader:Invader = Invader()
                let invaderHalfWidth:CGFloat = tempInvader.size.width/2
                let xPositionStart: CGFloat = size.width/2 - invaderHalfWidth - (CGFloat(invaderNum) * tempInvader.size.width) + CGFloat(10)
                tempInvader.position = CGPoint(x: xPositionStart + ((tempInvader.size.width+CGFloat(10))*(CGFloat(j-1))), y:CGFloat(self.size.height - CGFloat(i) * 46))
                tempInvader.invaderRow = invaderRow
                tempInvader.invaderColumn = invaderColumn
                
                addChild(tempInvader)
                if(i == rowsOfInvaders){
                    invadersWhoCanFire.append(tempInvader)
                }
                
            }
        }
    }
    
    func setupPlayer(){
        player.position = CGPoint(x: CGRectGetMidX(self.frame), y: player.size.height/2+10)
        addChild(player)
    }
    
    func moveInvaders(){
        var changeDirection = false
        enumerateChildNodesWithName("invader"){ node, stop in
            
            let invader = node as! SKSpriteNode
            let invaderHalfWidth = invader.size.width/2
            invader.position.x -= CGFloat(self.invaderSpeed)
            
            if(invader.position.x > self.rigthBounds-invaderHalfWidth || invader.position.x < self.leftBounds+invaderHalfWidth){
                changeDirection = true
            }
            
            if(changeDirection == true){
                self.invaderSpeed *= -1
                self.enumerateChildNodesWithName("invader") { node, stop in
                    let invader = node as! SKSpriteNode
                    invader.position.y -= CGFloat(46)
                }
                changeDirection = false
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        moveInvaders()
    }
    
    func invokeInvaderFire(){
        let fireBullet = SKAction.runBlock(){
            self.fireInvaderBullet()
        }
        let waitToFireInvaderBullet = SKAction.waitForDuration(1.5)
        let invaderFire = SKAction.sequence([fireBullet, waitToFireInvaderBullet])
        let repeatForeverAction = SKAction.repeatActionForever(invaderFire)
        runAction(repeatForeverAction)
    }
    
    func fireInvaderBullet(){
        let randomInvader = invadersWhoCanFire.randomElement()
        randomInvader.fireBullet(self)
    }
    
    
}
