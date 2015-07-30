//
//  Levels.swift
//  Poing
//
//  Created by Jhon Montanez on 7/30/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Levels: CCNode {
    
    var defaults = NSUserDefaults.standardUserDefaults()
    
    func loadFromCCB(){
        Gameplay().defaults.setBool(true, forKey: "fromLevels")

    }

    func back(){
        let level = CCBReader.loadAsScene("Episodes")
        let transition = CCTransition(fadeWithDuration: 0.8)
        CCDirector.sharedDirector().presentScene(level, withTransition: transition)
    }
    
    func level1(){
        Gameplay().defaults.setInteger(1, forKey: "levelButton")
        Gameplay().defaults.setBool(true, forKey: "fromLevels")
        let level = CCBReader.loadAsScene("Gameplay")
        let transition = CCTransition(fadeWithDuration: 0.8)
        CCDirector.sharedDirector().presentScene(level, withTransition: transition)
    }
}
