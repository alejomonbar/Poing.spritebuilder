//
//  End.swift
//  Poing
//
//  Created by Jhon Montanez on 8/12/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class End: CCNode {
    
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        
    let level = CCBReader.loadAsScene("Episodes")
    let transition = CCTransition(fadeWithDuration: 0.8)
    CCDirector.sharedDirector().presentScene(level, withTransition: transition)
        
    }
}
