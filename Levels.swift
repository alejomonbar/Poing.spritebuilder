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

    var number = 0
    
    weak var button2: CCButton!
    weak var button3: CCButton!
    weak var button4: CCButton!
    weak var button5: CCButton!
    weak var button6: CCButton!
    weak var button7: CCButton!
    weak var button8: CCButton!
    weak var button9: CCButton!
    
    var i = 1
    
    
    func didLoadFromCCB(){
        var buttons = [button2, button3, button4, button5, button6, button7, button8, button9]
        Gameplay().defaults.setBool(true, forKey: "fromLevels")
        number = Gameplay().defaults.integerForKey("currentEpisode")
        
        for button in buttons {
            i++
            if Gameplay().defaults.boolForKey("showbutton\(i + number)"){
                button.visible = true
            }
        }
    }
    

    func back(){
        let level = CCBReader.loadAsScene("Episodes")
        let transition = CCTransition(fadeWithDuration: 0.8)
        CCDirector.sharedDirector().presentScene(level, withTransition: transition)
    }
    
    func level1(){
        Gameplay().defaults.setInteger(number + 1, forKey: "levelButton")
        presentScene()
    }
    
    func level2(){
        Gameplay().defaults.setInteger(number + 2, forKey: "levelButton")
        presentScene()
    }
    func level3(){
        Gameplay().defaults.setInteger(number + 3, forKey: "levelButton")
        presentScene()
    }
    
    func level4(){
        Gameplay().defaults.setInteger(number + 4, forKey: "levelButton")
        presentScene()
    }
    
    func level5(){
        Gameplay().defaults.setInteger(number + 5, forKey: "levelButton")
        presentScene()
    }
    
    func level6(){
        Gameplay().defaults.setInteger(number + 6, forKey: "levelButton")
        presentScene()
    }
    
    func level7(){
        Gameplay().defaults.setInteger(number + 7, forKey: "levelButton")
        presentScene()
    }
    
    func level8(){
        Gameplay().defaults.setInteger(number + 8, forKey: "levelButton")
        presentScene()
    }
    
    func level9(){
        Gameplay().defaults.setInteger(number + 9, forKey: "levelButton")
        presentScene()
    }
    
    func presentScene(){
        let level = CCBReader.loadAsScene("Gameplay")
        let transition = CCTransition(fadeWithDuration: 0.8)
        CCDirector.sharedDirector().presentScene(level, withTransition: transition)
    }
}
