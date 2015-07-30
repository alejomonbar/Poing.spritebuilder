//
//  Menu.swift
//  Poing
//
//  Created by Jhon Montanez on 7/30/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Menu: CCNode {
    
    func cont(){
        Gameplay().defaults.setBool(false, forKey: "fromLevels")
        let level = CCBReader.loadAsScene("GamePlay")
        let transition = CCTransition(fadeWithDuration: 0.8)
        CCDirector.sharedDirector().presentScene(level, withTransition: transition)
    }
    func mainMenu(){
        let level = CCBReader.loadAsScene("Episodes")
        let transition = CCTransition(fadeWithDuration: 0.8)
        CCDirector.sharedDirector().presentScene(level, withTransition: transition)
    }
}
