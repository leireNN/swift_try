//
//  InvaderBullet.swift
//  spaceWar
//
//  Created by Leire Polo on 7/9/16.
//  Copyright © 2016 Leire Polo. All rights reserved.
//

import UIKit
import SpriteKit

class InvaderBullet: Bullet {
    
    override init(imageName: String, bulletSound: String?) {
        super.init(imageName: imageName, bulletSound: bulletSound)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    

}
