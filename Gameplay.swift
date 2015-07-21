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
    weak var contentLevel: CCNode!
    
    weak var gamePlay: CCNode!
    weak var menuScene: CCNode?
    
    var hero: Character!

    var xTouch: CGFloat?
    var yTouch: CGFloat?
    
    var screenHalf = CCDirector.sharedDirector().viewSize().width / 2
    
    var touching: Bool = false
    
    var heroPosition: CGPoint!
    var heroVelocity: CGPoint!
    
    var leftBar: Leftbar?
    
    var barExist: Bool = false
    
    var currentPositionX: CGFloat?
    var currentPositionY: CGFloat?
    
    var currentVelocityY:CGFloat?
    
    // Change the hero
    var chargeNext: Chargenext?
    var menuRightExist: Bool = false
    
    var apearWithAmount: CGFloat = 10
    var changeWithAmount: CGFloat = 30
    var differenceY: CGFloat!
    
    weak var powerScreen: CCSprite!
    
    
    var power: Float = 10 {
        didSet {
            powerScreen.scaleX = power / Float(10)
        }
    }
    
    
    var follow: CCActionFollow?
    
    func didLoadFromCCB(){
        
        gamePhysicsNode.collisionDelegate = self
        userInteractionEnabled = true
        multipleTouchEnabled = true
//        gamePhysicsNode.debugDraw = true
        loadLevel()
    
    }
    
    override func update(delta: CCTime) {

        if touching{
            heroPower()
        }
    
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        
        xTouch = touch.locationInWorld().x
        yTouch = touch.locationInWorld().y

        if xTouch > screenHalf {
            touching = true
            heroPower()
        } else {
            // Charge the bar when a touch in the left scree exist
            leftBar = CCBReader.load("Leftbar") as? Leftbar
            leftBar?.position = CGPoint(x: xTouch!, y: yTouch!)
            gamePlay.addChild(leftBar)
            barExist = true
        }
        
    }
    
    override func touchMoved(touch: CCTouch!, withEvent event: CCTouchEvent!) {

        currentPositionX = touch.locationInWorld().x
        currentPositionY = touch.locationInWorld().y
        
        if xTouch < screenHalf {
            
            var differenceX = currentPositionX! - xTouch!
            
            if currentPositionX < screenHalf {
                currentVelocityY = hero.physicsBody.velocity.y
                
                // change the position of the bar
                if abs(differenceX) < hero.maxSpeed {
                    leftBar?.cube.position = CGPoint(x: differenceX, y: 0)
                    moveCharacter(differenceX)
                } else {
                    var sign = differenceX / abs(differenceX)
                    moveCharacter(sign * hero.maxSpeed)
                    leftBar?.cube.position = CGPoint(x: sign * hero.maxSpeed, y: 0)
                }
            }
        }
        else {
                differenceY = currentPositionY! - yTouch!
            println(differenceY)
            println(-changeWithAmount)
                if abs(differenceY!) > apearWithAmount {
                    paused = true
                    if !menuRightExist{
                        chargeNext = CCBReader.load("Chargenext") as? Chargenext
                        chargeNext?.position = CGPoint(x: xTouch!, y: yTouch!)
                        if heroType == .Triangle{
                            chargeNext!.circleT.visible = true
                            chargeNext!.triangle.visible = false
                        } else if heroType == .Rectangle {
                            chargeNext!.circleR.visible = true
                            chargeNext!.rectangle.visible = false
                        }
                        gamePlay.addChild(chargeNext)
                        menuRightExist = true
                    }
                }
            }
    }
    
    override func touchEnded(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        
        touching = false
        
        hero.physicsBody.affectedByGravity = true
        hero.physicsBody.velocity = CGPoint(x: CGFloat(0), y: CGFloat(0))
        
        if barExist {
            gamePlay.removeChild(leftBar)
            barExist = false
        }
        
        if menuRightExist {
            paused = false
            if differenceY > changeWithAmount {
                if heroType == .Circle{
                    heroType = .Triangle
                } else if heroType == .Rectangle {
                    heroType = .Triangle
                } else {
                    heroType = .Circle
                }
             loadNextHero()
            } else if differenceY < -changeWithAmount {
                if heroType == .Circle {
                    heroType = .Rectangle
                } else if heroType == .Triangle {
                    heroType = .Rectangle
                } else {
                    heroType = .Circle
                }
                loadNextHero()
            }
            gamePlay.removeChild(chargeNext)
            menuRightExist = false
        }
    }
    
    func heroPower(){
        
        
        if heroType == .Circle  {
            
            power -= Float(0.01)
            
            hero.physicsBody.eachCollisionPair { (pair) -> Void in
                if !self.hero.jumped {
                    self.hero.physicsBody.applyImpulse(CGPoint(x: 0, y: 200))
                    self.hero.jumped = true
                    
                    NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: Selector("resetJump"), userInfo: nil, repeats: false)
                }
            }
        }
        if heroType == .Triangle {
            
            power -= Float(0.02)
            hero.physicsBody.velocity.y = CGFloat(100)
        }
        if heroType == .Rectangle {
            power -= Float(0.01)
            
            hero.physicsBody.affectedByGravity = false
            println(hero.physicsBody.affectedByGravity)
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
//            heroVelocity = CGPoint(x: 0, y: 0)
            hero = CCBReader.load("Rectangle") as! Character
        }
        
        hero.position = heroPosition
        hero.physicsBody.velocity = heroVelocity
        followHero()
        gamePhysicsNode.addChild(hero)
        
        
    }
    
    func moveCharacter(velocity: CGFloat){
        
        if currentPositionX! > xTouch! {
            println("right")
            hero.physicsBody.velocity = CGPoint(x: CGFloat(velocity), y: CGFloat(currentVelocityY!))
        } else if currentPositionX! < xTouch {
            println("left")
            hero.physicsBody.velocity = CGPoint(x: CGFloat(velocity), y: CGFloat(currentVelocityY!))
        }
    }
    
    func loadLevel(){
        
        let level = CCBReader.load("Levels/Level2") as! Level
        gamePhysicsNode.addChild(level)
        
        heroType = .Circle
        hero = CCBReader.load("Circle") as? Circle
        hero.position = level.startPoint.position
        
        gamePhysicsNode.addChild(hero)
        
        followHero()
    }
    
    func menu(){
        
        paused = true
        
        menuScene = CCBReader.load("Menuscene", owner: self) as CCNode!

        menuScene!.positionType = CCPositionType(xUnit: .Normalized, yUnit: .Normalized, corner: .BottomLeft)
        menuScene!.position = CGPoint(x: 0.5, y: 0.5)
        addChild(menuScene)
 
    }
    
    func restart(){
        let restartScene = CCBReader.loadAsScene("Gameplay")
        let transition = CCTransition(fadeWithDuration: 0.8)
        CCDirector.sharedDirector().presentScene(restartScene, withTransition: transition)
    }
    
    func followHero(){
        follow = CCActionFollow(target: hero, worldBoundary: gamePhysicsNode.boundingBox())
        gamePhysicsNode.position = follow!.currentOffset()
        gamePhysicsNode.runAction(follow)
    }
    
    
}
