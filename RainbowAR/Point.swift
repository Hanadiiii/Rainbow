//
//  Point.swift
//  RainbowAR
//
//  Created by Hanadi AlOthman on 10/01/2019.
//  Copyright © 2019 Steve Lederer. All rights reserved.
//

import SpriteKit

enum PointState: String {
    case unicorn = "Unicorn"
    case apple = "Apple"
    case burrito = "Burrito"
    case fries = "Fries"
    case icecream = "Icecream"
    case pancake = "Pancake"
    
    static func random() -> String {
        let emojiToGetRandomly = [PointState.unicorn, PointState.apple, PointState.burrito, PointState.fries, PointState.icecream, PointState.pancake]
        let index = Int(arc4random_uniform(UInt32(emojiToGetRandomly.count)))
        let emoji = emojiToGetRandomly[index].rawValue
        return emoji
    }
}

class Point: SKSpriteNode {
    
}
