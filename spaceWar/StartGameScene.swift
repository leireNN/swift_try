//
//  StartGameScene.swift
//  spaceWar
//
//  Created by Leire Polo on 7/9/16.
//  Copyright © 2016 Leire Polo. All rights reserved.
//

import UIKit
import SpriteKit

var invaderNum = 1

class StartGameScene: SKScene {
    
    

    
    override func didMoveToView(view: SKView){
        
        
        let startGameButton = SKSpriteNode(imageNamed: "newgamebtn")
        startGameButton.position = CGPointMake(size.width/2, size.width/2-100)
        startGameButton.name = "startgame"
        addChild(startGameButton)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let touch = touches.first! as UITouch
        let touchLocation = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(touchLocation)
        
        if(touchedNode.name == "startgame"){
            let gameOverScene = GameScene(size: size)
            gameOverScene.scaleMode = scaleMode
            let transitionType = SKTransition.flipHorizontalWithDuration(1.0)
            view?.presentScene(gameOverScene, transition: transitionType)
        }
    }
    
    
}
