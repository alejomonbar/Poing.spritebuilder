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
        Gameplay().defaults.setBool( true , forKey: "tutorial1")
        Gameplay().defaults.setBool( true , forKey: "tutorial1b")

        Gameplay().defaults.setBool( true , forKey: "tutorial2")
        Gameplay().defaults.setBool( true , forKey: "tutorial3")
        Gameplay().defaults.setBool( true , forKey: "tutorial4")
        Gameplay().defaults.setBool( true , forKey: "tutorial5")
        
        Gameplay().defaults.setInteger(1, forKey: "level")
        Gameplay().defaults.setInteger(1, forKey: "bestLevel")

        let level = CCBReader.loadAsScene("Gameplay")
        let transition = CCTransition(fadeWithDuration: 1.2)
        CCDirector.sharedDirector().presentScene(level, withTransition: transition)
    }

}
