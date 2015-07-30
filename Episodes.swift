//
//  Episodes.swift
//  Poing
//
//  Created by Jhon Montanez on 7/30/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Episodes: CCNode {
    
    func episode1(){
        Gameplay().defaults.setInteger(0, forKey: "currentEpisode")
        let level = CCBReader.loadAsScene("Levels")
        let transition = CCTransition(fadeWithDuration: 0.8)
        CCDirector.sharedDirector().presentScene(level, withTransition: transition)
    }
    
    func episode2(){
        Gameplay().defaults.setInteger(9, forKey: "currentEpisode")
        let level = CCBReader.loadAsScene("Levels")
        let transition = CCTransition(fadeWithDuration: 0.8)
        CCDirector.sharedDirector().presentScene(level, withTransition: transition)
    }
    
    func episode3(){
        Gameplay().defaults.setInteger(18, forKey: "currentEpisode")
        let level = CCBReader.loadAsScene("Levels")
        let transition = CCTransition(fadeWithDuration: 0.8)
        CCDirector.sharedDirector().presentScene(level, withTransition: transition)
    }
}
