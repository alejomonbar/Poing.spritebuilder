//
//  Character.swift
//  Poing
//
//  Created by Jhon Montanez on 7/10/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

class Character: CCSprite {
    
    var maxSpeed: CGFloat = 80
    var jumped: Bool = false
    weak var foot1: CCSprite!
    weak var foot2: CCSprite!
    weak var body: CCSprite!
    
    var hi = false
//    func changePhysicsBody() {
//        self.physicsBody = CCPhysicsBody(circleOfRadius: 10, andCenter: ccp(10, 10))
//        self.physicsBody.allowsRotation = false
//            }
//    
    func death(){
        self.animationManager.runAnimationsForSequenceNamed("death")
    }
    
    func walking(){
       if hi == false {
            self.animationManager.runAnimationsForSequenceNamed("walking")
            hi = true
        }
    }
    
    func jumping(){
        
        self.animationManager.runAnimationsForSequenceNamed("jump")

    }
    
    func flipL(){
        foot1.flipX = true
        foot2.flipX = true
        body.flipX = true
    }
    
    func flipR(){
        foot1.flipX = false
        foot2.flipX = false
        body.flipX = false
    }
}
