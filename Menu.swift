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
        animationManager.runAnimationsForSequenceNamed("pushPlay")
        self.scheduleOnce("continued", delay: 1)


    }
    func mainMenu(){
        animationManager.runAnimationsForSequenceNamed("pushMainMenu")
        self.scheduleOnce("mainMenuCall", delay: 1)
    }
    
    func butonTouched() {
    }
    
    func continued() {
        Gameplay().defaults.setBool(false, forKey: "fromLevels")
        let level = CCBReader.loadAsScene("Gameplay")
        let transition = CCTransition(fadeWithDuration: 0.8)
        CCDirector.sharedDirector().presentScene(level, withTransition: transition)
    }
    
    func mainMenuCall(){
        let level = CCBReader.loadAsScene("Episodes")
        let transition = CCTransition(fadeWithDuration: 0.8)
        CCDirector.sharedDirector().presentScene(level, withTransition: transition)
    }
}
