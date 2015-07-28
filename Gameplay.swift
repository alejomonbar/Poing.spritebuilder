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

class Gameplay: CCNode{
    
    var heroType: HeroType?
    
    weak var gamePhysicsNode: CCPhysicsNode!
    weak var levelNode: CCNode!
    weak var contentLevel: CCNode!
    
    weak var gamePlay: CCNode!
    weak var menuScene: CCNode?
    
    weak var heroP: CCButton!
    
    weak var win: CCNode?
    
    var hero: Character!

    var xTouch: CGFloat?
    var yTouch: CGFloat?
    
    var xTouchL: CGFloat?
    
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
    
    // characteristics of the level
    var powerT: Float!
    var powerC: Float!
    var powerR: Float!
    
    weak var powerScreen: CCSprite!
    
    var power: Float = 10 {
        didSet {
            powerScreen.scaleX = power / Float(10)
        }
    }
    
    var follow: CCActionFollow?
    
    let firstLevel: Int = 1
    let lastLevel: Int = 3
    
    var currentLevel: Int = 1
    var currentLevelPath: String {
        if currentLevel < firstLevel || currentLevel > lastLevel {
            currentLevel = 1
        }
        return "Levels/Level\(currentLevel)"
    }
    
    weak var callT: CCButton!
    weak var callR: CCButton!
    weak var callC: CCButton!
    
    var touchMovedRight: Bool = false
    
    weak var menuR: CCButton!
    
    var mapExist: Bool = false
    
    var firstTime: Bool = true
    
    var scaleH: Float = 0
    
    func didLoadFromCCB(){

        gamePhysicsNode.collisionDelegate = self
        userInteractionEnabled = true
        multipleTouchEnabled = true
//        gamePhysicsNode.debugDraw = true
        
        callT.exclusiveTouch = false
        callR.exclusiveTouch = false
        callC.exclusiveTouch = false
        heroP.exclusiveTouch = false
        
        
        loadLevel()
    }
    
    override func update(delta: CCTime) {

        if heroP.touchInside{
                heroPower()
        } else {
            hero.physicsBody.affectedByGravity = true
        }
        
        if CGRectGetMaxY(hero.boundingBox()) < CGRectGetMinY(gamePhysicsNode.boundingBox()) {
            restart()
        }
        
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        println("began")
        xTouch = touch.locationInWorld().x
        yTouch = touch.locationInWorld().y
        
        if xTouch < screenHalf  {
            xTouchL = touch.locationInWorld().x
            // Charge the bar when a touch in the left scree exist
            leftBar = CCBReader.load("Leftbar") as? Leftbar
            println(yTouch)
            leftBar?.position = CGPoint(x: xTouch!, y: yTouch! + CGFloat(35))
            for child in gamePlay.children {
                if let child = child as? Leftbar{
                    gamePlay.removeChild(child)
                }
            }
            gamePlay.addChild(leftBar)
            barExist = true
                
        }
        
    }
    
    override func touchMoved(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        
        println("moved")
        currentPositionX = touch.locationInWorld().x
        currentPositionY = touch.locationInWorld().y
        println(currentPositionX)
        touchMovedRight = false
        if xTouchL != nil {
            
            var differenceX = currentPositionX! - xTouchL!
            
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
            } else {
                touchMovedRight = true
            }
        }

    }
    
    override func touchEnded(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        println("ended")

        
        if barExist && touch.locationInWorld().x <= screenHalf || touchMovedRight {
            println("removeBar")
            gamePlay.removeChild(leftBar)
            barExist = false
            xTouchL = nil
            touchMovedRight = false
        }
    }
    
    func heroPower(){
        println("power")
        if power > 0 {
        if heroType == .Circle  {
            hero.physicsBody.eachCollisionPair { (pair) -> Void in
                if !self.hero.jumped {
                    self.hero.physicsBody.applyImpulse(CGPoint(x: 0, y: 180))
                    self.hero.jumped = true
                    self.power -= self.powerC
                    NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: Selector("resetJump"), userInfo: nil, repeats: false)
                }


            }
        }
        if heroType == .Triangle {
            
            power -= powerT
            hero.physicsBody.velocity.y = CGFloat(100)
        }
        if heroType == .Rectangle {
            power -= powerR
            hero.physicsBody.velocity.y = CGFloat(0)
            hero.physicsBody.affectedByGravity = false
            println(hero.physicsBody.affectedByGravity)
        }
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
//        followHero()
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
        gamePhysicsNode.addChild(hero)
        followHero()
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
        
        power = 10
        levelNode.removeAllChildren()
        for child in gamePhysicsNode.children {
            if let child = child as? Character {
                gamePhysicsNode.removeChild(child)
            }
        }
        
        if let win = win {
            self.removeChild(win)
        }
        
        let level = CCBReader.load(currentLevelPath) as! Level
        // Charge the characteristics about how the characters spend the power from the level
        powerT = level.powerT
        powerR = level.powerR
        powerC = level.powerC
        // Doing the level size equal to gamePhysicsNode size
        gamePhysicsNode.contentSize = level.contentSize
        
        scaleH = Float(CCDirector.sharedDirector().viewSize().width / level.contentSize.width)
        
        levelNode.addChild(level)
        heroType = .Circle
        hero = CCBReader.load("Circle") as? Character
        hero.position = level.startPoint.position
        
        gamePhysicsNode.addChild(hero)
        
        followHero()
        
        paused = false
        
        // It looks if a map already have been presented in the screen for first time
        if firstTime {
            map()
            animationManager.runAnimationsForSequenceNamed("TimeF")
        }
    }
    
    func menu(){
        
        paused = true
        
        if mapExist {
            if firstTime{
                animationManager.runAnimationsForSequenceNamed("MenuB")
                firstTime = false
            }
            followHero()
            gamePhysicsNode.scale = 1
            mapExist = false
            aftermenu()
            return
            
        }
        
        if menuScene != nil {
            aftermenu()
            gamePlay.removeChild(menuScene)
            return
        }
        unableButtons()
        userInteractionEnabled = false
        menuScene = CCBReader.load("Menuscene", owner: self) as CCNode!

        menuScene!.positionType = CCPositionType(xUnit: .Normalized, yUnit: .Normalized, corner: .BottomLeft)
        menuScene!.position = CGPoint(x: 0.5, y: 0.5)
        gamePlay.addChild(menuScene)
        menuR.title = "continue"

 
    }
    
    func restart(){
        if menuScene != nil {
            self.removeChild(menuScene)
        }
        presentTransition()
        userInteractionEnabled = true
        paused = false
        menuR.title = "menu"
        enableButtons()
        loadLevel()
    }
    
    func followHero() {
        follow = CCActionFollow(target: hero, worldBoundary: levelNode.boundingBox())
        gamePhysicsNode.position = follow!.currentOffset()
        gamePhysicsNode.runAction(follow)
    }

    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, hero: CCNode!, door: CCNode!) -> ObjCBool {
        paused = true
        let win = CCBReader.load("Win", owner: self)
        win!.positionType = CCPositionType(xUnit: .Normalized, yUnit: .Normalized, corner: .BottomLeft)
        win!.position = CGPoint(x: 0, y: 0)
        addChild(win)
        currentLevel++
        firstTime = true
        return true

    }
    
    func reload(){
        currentLevel--
        presentTransition()
        loadLevel()
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, hero: CCNode!, mushroom: CCNode!) -> ObjCBool {
        mushroom.removeFromParent()
        return true
        
    }
    
    func presentTransition(){
        self.animationManager.runAnimationsForSequenceNamed("Transition")
    }
    
    
    func map() {
        userInteractionEnabled = false
        gamePhysicsNode.position = CGPoint.zeroPoint
        paused = true
        gamePhysicsNode.scale = scaleH
        gamePlay.removeChild(menuScene)
        mapExist = true
        menuR.title = "continue"
        unableButtons()
    }

    func unableButtons(){
        heroP.userInteractionEnabled = false
        callT.userInteractionEnabled = false
        callC.userInteractionEnabled = false
        callR.userInteractionEnabled = false
    }
    
    func enableButtons(){
        heroP.userInteractionEnabled = true
        callT.userInteractionEnabled = true
        callC.userInteractionEnabled = true
        callR.userInteractionEnabled = true
    }
    
    func aftermenu() {
        userInteractionEnabled = true
        paused = false
        menuR.title = "menu"
        enableButtons()
        
    }
}
