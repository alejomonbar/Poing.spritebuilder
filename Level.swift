//
//  Level.swift
//  Poing
//
//  Created by Jhon Montanez on 7/20/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Level: CCNode {
    weak var startPoint: CCNode!
    
    var powerT: Float = 0
    var powerR: Float = 0
    var powerC: Float = 0
    
    var toGet3: Float = 0
    var toGet2: Float = 0
    
    var mushroom: Int = 0
}
