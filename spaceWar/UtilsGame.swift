//
//  UtilsGame.swift
//  spaceWar
//
//  Created by Leire Polo on 13/9/16.
//  Copyright © 2016 Leire Polo. All rights reserved.
//
import SpriteKit
import UIKit

class UtilsGame: UIColor {
    
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

}
