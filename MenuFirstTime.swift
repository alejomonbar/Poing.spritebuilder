//
//  MenuFirstTime.swift
//  Poing
//
//  Created by Jhon Montanez on 7/30/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class MenuFirstTime: CCNode {
    
    func start(){
        Gameplay().defaults.setInteger(1, forKey: "level")
        let level = CCBReader.loadAsScene("Gameplay")
        let transition = CCTransition(fadeWithDuration: 0.8)
        CCDirector.sharedDirector().presentScene(level, withTransition: transition)
        Gameplay().defaults.setInteger(1, forKey: "bestLevel")
    }

}
