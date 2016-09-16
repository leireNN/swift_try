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
var scorePlayer = 0

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
    var invadersWhoCanFly: [Invader] = [Invader]()
    let player:Player = Player()
    let maxLevels = 3
    let motionManager: CMMotionManager = CMMotionManager()
    var accelerationX: CGFloat = 0.0
    var accelerationY: CGFloat = 0.0
    var backgroundColorCustom = UIColor.orange
    var scoreText = SKLabelNode()
    
    
    override func didMove(to view: SKView) {
        self.backgroundColor = backgroundColorCustom
        
        
        //Fire button
        let fireButton = SKSpriteNode(imageNamed: "maki.png")
        fireButton.position = CGPoint(x: size.width-100,y: 100)
        fireButton.name = "fireButton"
        fireButton.setScale(0.25)
        addChild(fireButton)
        
        //Score label and text
        let scoreLabel = SKLabelNode(text: "Score:")
        scoreLabel.position = CGPoint(x: 100, y: size.height)
        addChild(scoreLabel)
        
        scoreText.text = String(scorePlayer)
        scoreText.position  = CGPoint(x: 200, y: size.height)
        addChild(scoreText)
        
        
        
    
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        self.physicsBody?.categoryBitMask = CollisionCategories.EdgeBody
        
        let swipeRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipedRight(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        
        let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipedLeft(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        
        let swipeUp:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipedUp(_:)))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)
        
        
        let swipeDown:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipedDown(_:)))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
        
        let utilsGame = UtilsGame()
        backgroundColor = utilsGame.UIColorFromRGB(0xEECC91)
        
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
        
        for i in 0..<rowsOfInvaders+1 {
            invaderRow = i
            for j in 0..<numberOfInvaders+1 {
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
        player.position = CGPoint(x: self.frame.midX, y: player.size.height/2+10)
        addChild(player)
    }
    
    func moveInvaders(){
        var changeDirection = false
        enumerateChildNodes(withName: "invader"){ node, stop in
            
            let invader = node as! SKSpriteNode
            let invaderHalfWidth = invader.size.width/2
            invader.position.x -= CGFloat(self.invaderSpeed)
            
            if(invader.position.x > self.rigthBounds-invaderHalfWidth || invader.position.x < self.leftBounds+invaderHalfWidth){
                changeDirection = true
            }
            
            if(changeDirection == true){
                self.invaderSpeed *= -1
                self.enumerateChildNodes(withName: "invader") { node, stop in
                    let invader = node as! SKSpriteNode
                    invader.position.y -= CGFloat(46)
                }
                changeDirection = false
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        moveInvaders()
    }
    
    func invokeInvaderFire(){
        let fireBullet = SKAction.run(){
            self.fireInvaderBullet()
        }
        let waitToFireInvaderBullet = SKAction.wait(forDuration: 1.5)
        let invaderFire = SKAction.sequence([fireBullet, waitToFireInvaderBullet])
        let repeatForeverAction = SKAction.repeatForever(invaderFire)
        run(repeatForeverAction)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        
        if(touchedNode.name == "fireButton"){
            player.fireBullet(self, accelerationX: accelerationX, accelerationY: accelerationY)
        }

        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
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
            
            var invadersPerRow = invaderNum*2+1
            let theInvader = firstBody.node as! Invader
            let newInvaderRow = theInvader.invaderRow - 1
            let newInvaderColumn = theInvader.invaderColumn
            if(newInvaderRow >= 0){
                self.enumerateChildNodes(withName: "invader"){node, stop in
                    let invader = node as!Invader
                    scorePlayer += invader.value
                    self.scoreText.text = String(scorePlayer)
                    
                    if invader.invaderRow == newInvaderRow && invader.invaderColumn == newInvaderColumn{
                        self.invadersWhoCanFire.append(invader)
                        stop.pointee = true
                    }
                }
                let invaderIndex = findIndex(array: invadersWhoCanFire, valueToFind:firstBody.node as! Invader)
                if(invaderIndex != nil){
                    invadersWhoCanFire.remove(at: invaderIndex!)
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
        for (index, value) in array.enumerated() {
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
            let transitionType = SKTransition.flipHorizontal(withDuration: 0.5)
            view?.presentScene(levelCompleteScene, transition: transitionType)
        }else{
            invaderNum = 1
            newGame()
        }
    }
    
    func newGame(){
        let gameOverScene = StartGameScene(size:size)
        gameOverScene.scaleMode = scaleMode
        let transitionType = SKTransition.flipHorizontal(withDuration: 0.5)
        view?.presentScene(gameOverScene, transition: transitionType)
    }
    
    func setupAccelerometer(){
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (accelerometerData, error) in
            let acceleration = accelerometerData?.acceleration
            self.accelerationX = CGFloat(acceleration!.x)
            self.accelerationY = CGFloat(acceleration!.y)
        }
    }
    
    override func didSimulatePhysics() {
        player.physicsBody?.velocity = CGVector(dx: accelerationX * 600, dy: accelerationY * 600)
        
    }
    
    func swipedRight(_ sender:UISwipeGestureRecognizer){
        print("swiped right")
        player.rotateRight()
        
    }
    
    func swipedLeft(_ sender:UISwipeGestureRecognizer){
        print("swiped left")
        player.rotateLeft()
    }
    
    func swipedUp(_ sender:UISwipeGestureRecognizer){
        print("swiped up")
    }
    
    func swipedDown(_ sender:UISwipeGestureRecognizer){
        print("swiped down")
    }
    
    
}
