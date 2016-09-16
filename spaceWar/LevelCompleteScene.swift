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
    
    override func didMove(to view:SKView) {
        self.backgroundColor = SKColor.black
        let startGameButton = SKSpriteNode(imageNamed: "nextlevelbtn.png")
        startGameButton.position = CGPoint(x: size.width/2, y: size.height/2-100)
        startGameButton.name = "nextlevel"
        addChild(startGameButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        if(touchedNode.name == "nextlevel"){
            let gameOverScene = GameScene(size: size)
            gameOverScene.scaleMode = scaleMode
            let transitionType = SKTransition.flipHorizontal(withDuration: 0.5)
            view?.presentScene(gameOverScene, transition: transitionType)
        }
    }

}
