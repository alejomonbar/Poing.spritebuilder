//
//  NextLevel.swift
//  Poing
//
//  Created by Jhon Montanez on 7/22/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation


class Win: CCNode {
    
    weak var energySaved: CCLabelTTF!
    weak var bestScoreL: CCLabelTTF!
    weak var star1: CCNode!
    weak var star2: CCNode!
    weak var star3: CCNode!
    // Show the stars if the level of energy is over that value
    var percentTo3 = Gameplay().defaults.floatForKey("toGet3")
    var percentTo2 = Gameplay().defaults.floatForKey("toGet2")
    
    var currentLevel = Gameplay().defaults.integerForKey("level")
    
    func didLoadFromCCB(){
        var currentScore = Gameplay().defaults.floatForKey("level\(currentLevel)") * 10
        var bestScore = Gameplay().defaults.integerForKey("Best\(currentLevel)")
        println(bestScore)
        if Int(currentScore) > bestScore {
            Gameplay().defaults.setInteger(Int(currentScore), forKey:"Best\(currentLevel)")
            bestScore = Gameplay().defaults.integerForKey("Best\(currentLevel)")
        }
        
        if currentScore >= percentTo3 {
            star1.visible = true
            star2.visible = true
            star3.visible = true
        } else if currentScore >= percentTo2 {
            star1.visible = true
            star2.visible = true
        } else {
            star1.visible = true
        }
        energySaved.string = String(Int(currentScore))
        bestScoreL.string = String(Int(bestScore))
        
    }
    
    func nextLevel(){
        if currentLevel > 27 {
            if Gameplay().defaults.boolForKey("EndFirstTime"){
                let level = CCBReader.loadAsScene("End")
                let transition = CCTransition(fadeWithDuration: 0.8)
                CCDirector.sharedDirector().presentScene(level, withTransition: transition)
            } else {
                let level = CCBReader.loadAsScene("Episodes")
                let transition = CCTransition(fadeWithDuration: 0.8)
                CCDirector.sharedDirector().presentScene(level, withTransition: transition)
            }

            return
        }
        
        Gameplay().presentGamePlay()
    }
    
    func reload(){
        Gameplay().defaults.setInteger(currentLevel - 1, forKey: "level")
        Gameplay().defaults.setBool(true, forKey: "presentMap")
        Gameplay().presentGamePlay()
        
    }

}
