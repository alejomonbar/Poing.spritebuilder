//
//  Gameplay.swift
//  Poing
//
//  Created by Jhon Montanez on 7/5/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

enum HeroType {
    case Circle
    case Triangle
    case Rectangle
}

class Gameplay: CCNode {
    
    var heroType: HeroType?
    
    weak var gamePhysicsNode: CCPhysicsNode!
    weak var levelNode: CCNode!
    weak var startPoint: CCNode!
    weak var contentLevel: CCNode!
    
    var hero: Character!
    
    var direction: UISwipeGestureRecognizerDirection?
    
    var xTouch: CGFloat?
    var screenHalf = CCDirector.sharedDirector().viewSize().width / 2
    
    var touching: Bool = false

    
    var heroPosition: CGPoint!
    var heroVelocity: CGPoint!
    
    var disableMovement: Bool = false
    
    func didLoadFromCCB(){
        
        gamePhysicsNode.collisionDelegate = self
        self.userInteractionEnabled = true
        gamePhysicsNode.debugDraw = true
        
        heroType = HeroType.Circle
        hero = CCBReader.load("Circle") as? Circle
        hero.position = startPoint.position
        
        gamePhysicsNode.addChild(hero)
    
    }
    
    override func update(delta: CCTime) {
    
        if touching{
            heroPower()
        }
    
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        xTouch = touch.locationInWorld().x
        println("began")

        if xTouch > screenHalf {
            touching = true
            heroPower()
        }
        
    }
    
    override func touchMoved(touch: CCTouch!, withEvent event: CCTouchEvent!) {

        var currentPosition = touch.locationInWorld().x
        
        if !disableMovement {
//            if currentPosition < screenHalf {
                var currentVelocityY = hero.physicsBody.velocity.y
                if currentPosition > xTouch {
                    println("right")
                    hero.physicsBody.velocity = CGPoint(x: CGFloat(hero.speed), y: CGFloat(currentVelocityY))
                } else if currentPosition < xTouch {
                    println("left")
                    hero.physicsBody.velocity = CGPoint(x: CGFloat(-hero.speed), y: CGFloat(currentVelocityY))
                }
//            }
        }
    }
    
    override func touchEnded(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        
        touching = false
        hero.physicsBody.velocity = CGPoint(x: CGFloat(0), y: CGFloat(0))
    }
    
    func heroPower(){
        if heroType == .Circle  {
            hero.physicsBody.eachCollisionPair { (pair) -> Void in
                if !self.hero.jumped {
                    self.hero.physicsBody.applyImpulse(CGPoint(x: 0, y: 300))
                    self.hero.jumped = true
                    
                    NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: Selector("resetJump"), userInfo: nil, repeats: false)
                }
            }
        }
        if heroType == .Triangle {
            hero.physicsBody.velocity.y = CGFloat(100)
            disableMovement = true
        }
        if heroType == .Rectangle {
            hero.physicsBody.affectedByGravity = false
        }
        
    }
    
    func resetJump() {
        hero.jumped = false
    }
    
    func callTriangle() {
        heroType = .Triangle
        loadNextHero()
    }
    
    func callRectangle(){
        heroType = .Rectangle
        loadNextHero()
    }
    
    func callCircle(){
        heroType = .Circle
        loadNextHero()

        
    }
    
    func loadNextHero() {
        
        heroPosition = hero.position
        heroVelocity = hero.physicsBody.velocity
        gamePhysicsNode.removeChild(hero)
        
        if heroType == .Circle{
            hero = CCBReader.load("Circle") as! Character
        } else if heroType == .Triangle {
            hero = CCBReader.load("Triangle") as! Character
        } else {
            hero = CCBReader.load("Rectangle") as! Character
        }
        
        hero.position = heroPosition
        hero.physicsBody.velocity = heroVelocity
        gamePhysicsNode.addChild(hero)
    }
    
    
}
