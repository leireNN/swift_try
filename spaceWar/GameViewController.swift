//
//  GameScene.swift
//  spaceWar
//
//  Created by Leire Polo on 7/9/16.
//  Copyright (c) 2016 Leire Polo. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = StartGameScene(size: view.bounds.size)
        let skView = view as! SKView
        
        //skView.showsFPS = true
        //skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .ResizeFill
        skView.presentScene(scene)
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}