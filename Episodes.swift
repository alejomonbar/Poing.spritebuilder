//
//  Episodes.swift
//  Poing
//
//  Created by Jhon Montanez on 7/30/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Episodes: CCNode {
    
    weak var two: CCButton!
    weak var three: CCButton!
    
    func didLoadFromCCB(){
        var bestLevel = Gameplay().defaults.integerForKey("bestLevel")
        println(bestLevel)
        println(Gameplay().defaults.boolForKey("episode2"))
        println(Gameplay().defaults.integerForKey("bestLevel"))
        // Desactive the button from chose each episode
        
        if bestLevel < 18 {
            three.visible = false
            if bestLevel < 9 {
                two.visible = false
            } else {
                two.visible = true
            }
        } else {
            three.visible = true
        }

        
    }
    
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
