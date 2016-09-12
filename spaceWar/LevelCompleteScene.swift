//
//  LevelCompleteScene.swift
//  spaceWar
//
//  Created by Leire Polo on 8/9/16.
//  Copyright © 2016 Leire Polo. All rights reserved.
//

import Foundation
import SpriteKit

class LevelCompleteScene: SKScene {
    
    override func didMoveToView(view:SKView) {
        self.backgroundColor = SKColor.blackColor()
        let startGameButton = SKSpriteNode(imageNamed: "nextlevelbtn.png")
        startGameButton.position = CGPointMake(size.width/2, size.height/2-100)
        startGameButton.name = "nextlevel"
        addChild(startGameButton)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch
        let touchLocation = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(touchLocation)
        if(touchedNode.name == "nextlevel"){
            let gameOverScene = GameScene(size: size)
            gameOverScene.scaleMode = scaleMode
            let transitionType = SKTransition.flipHorizontalWithDuration(0.5)
            view?.presentScene(gameOverScene, transition: transitionType)
        }
    }

}
