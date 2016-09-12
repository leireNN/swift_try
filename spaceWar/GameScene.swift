//
//  GameScene.swift
//  spaceWar
//
//  Created by Leire Polo on 7/9/16.
//  Copyright (c) 2016 Leire Polo. All rights reserved.
//

import SpriteKit
import CoreMotion

var invaderNum = 1

struct CollisionCategories{
    static let Invader : UInt32 = 0x1 << 0
    static let Player: UInt32 = 0x1 << 1
    static let InvaderBullet: UInt32 = 0x1 << 2
    static let PlayerBullet: UInt32 = 0x1 << 3
    static let EdgeBody: UInt32 = 0x1 << 4
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let rowsOfInvaders = 4
    var invaderSpeed = 2
    let leftBounds = CGFloat(30)
    var rigthBounds = CGFloat(0)
    var invadersWhoCanFire:[Invader] = [Invader]()
    let player:Player = Player()
    let maxLevels = 3
    let motionManager: CMMotionManager = CMMotionManager()
    var accelerationX: CGFloat = 0.0
    var accelerationY: CGFloat = 0.0
    
    override func didMoveToView(view: SKView) {
    
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        self.physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        self.physicsBody?.categoryBitMask = CollisionCategories.EdgeBody
        
        let swipeRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipedRight(_:)))
        swipeRight.direction = .Right
        view.addGestureRecognizer(swipeRight)
        
        
        let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipedLeft(_:)))
        swipeLeft.direction = .Left
        view.addGestureRecognizer(swipeLeft)
        
        
        let swipeUp:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipedUp(_:)))
        swipeUp.direction = .Up
        view.addGestureRecognizer(swipeUp)
        
        
        let swipeDown:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipedDown(_:)))
        swipeDown.direction = .Down
        view.addGestureRecognizer(swipeDown)
        
        backgroundColor = SKColor.blackColor()
        rigthBounds = self.size.width-30
        NSLog("We have loaded the start screen")
        setupInvaders()
        setupPlayer()
        invokeInvaderFire()
        setupAccelerometer()
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
        if(invadersWhoCanFire.isEmpty){
            invaderNum += 1
            levelComplete()
        }else{
            let randomInvader = invadersWhoCanFire.randomElement()
            randomInvader.fireBullet(self)
        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        player.fireBullet(self, accelerationX: accelerationX, accelerationY: accelerationY)
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if((firstBody.categoryBitMask & CollisionCategories.Invader != 0) && (secondBody.categoryBitMask & CollisionCategories.PlayerBullet != 0)){
            NSLog("Invader and PlayerBuller contact!")
            if(contact.bodyA.node?.parent == nil || contact.bodyB.node?.parent == nil){
                return
            }
            
            let invadersPerRow = invaderNum*2+1
            let theInvader = firstBody.node as! Invader
            let newInvaderRow = theInvader.invaderRow - 1
            let newInvaderColumn = theInvader.invaderColumn
            if(newInvaderRow >= 1){
                self.enumerateChildNodesWithName("invader"){node, stop in
                    let invader = node as!Invader
                    if invader.invaderRow == newInvaderRow && invader.invaderColumn == newInvaderColumn{
                        self.invadersWhoCanFire.append(invader)
                        stop.memory = true
                    }
                }
                let invaderIndex = findIndex(invadersWhoCanFire, valueToFind:firstBody.node as! Invader)
                if(invaderIndex != nil){
                    invadersWhoCanFire.removeAtIndex(invaderIndex!)
                }
                theInvader.removeFromParent()
                secondBody.node?.removeFromParent()
            }
        }
        if((firstBody.categoryBitMask & CollisionCategories.Player != 0) && (secondBody.categoryBitMask & CollisionCategories.InvaderBullet != 0)){
            NSLog("Player and InvaderBullet contact!")
            player.die()
        }
        if((firstBody.categoryBitMask & CollisionCategories.Invader != 0) && (secondBody.categoryBitMask & CollisionCategories.Player != 0)){
            NSLog("Invader and Player contact!")
            player.kill()
        }
    }
    
    func findIndex<T: Equatable>(array: [T], valueToFind: T) -> Int? {
        for (index, value) in EnumerateSequence(array) {
            if value == valueToFind {
                return index
            }
        }
        return nil
    }
    
    func levelComplete(){
        if(invaderNum <= maxLevels){
            let levelCompleteScene = LevelCompleteScene(size: size)
            levelCompleteScene.scaleMode = scaleMode
            let transitionType = SKTransition.flipHorizontalWithDuration(0.5)
            view?.presentScene(levelCompleteScene, transition: transitionType)
        }else{
            invaderNum = 1
            newGame()
        }
    }
    
    func newGame(){
        let gameOverScene = StartGameScene(size:size)
        gameOverScene.scaleMode = scaleMode
        let transitionType = SKTransition.flipHorizontalWithDuration(0.5)
        view?.presentScene(gameOverScene, transition: transitionType)
    }
    
    func setupAccelerometer(){
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue()!) { (accelerometerData, error) in
            let acceleration = accelerometerData?.acceleration
            self.accelerationX = CGFloat(acceleration!.x)
            self.accelerationY = CGFloat(acceleration!.y)
        }
    }
    
    override func didSimulatePhysics() {
        player.physicsBody?.velocity = CGVector(dx: accelerationX * 600, dy: accelerationY * 600)
        
    }
    
    func swipedRight(sender:UISwipeGestureRecognizer){
        print("swiped right")
        player.rotateRight()
        
    }
    
    func swipedLeft(sender:UISwipeGestureRecognizer){
        print("swiped left")
        player.rotateLeft()
    }
    
    func swipedUp(sender:UISwipeGestureRecognizer){
        print("swiped up")
    }
    
    func swipedDown(sender:UISwipeGestureRecognizer){
        print("swiped down")
    }
    
    
}
