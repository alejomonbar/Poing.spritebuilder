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
    
    var currentLevel: Int = 1
    
    weak var callT: CCButton!
    weak var callR: CCButton!
    weak var callC: CCButton!
    
    var touchMovedRight: Bool = false
    
    weak var menuR: CCButton!
    
    var mapExist: Bool = false
    
    var firstTime: Bool = true
    
    var scaleH: Float = 0
    
    var mushrooms: Int = 0
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var differenceX: CGFloat!
    
    weak var menuPosition: CCNode!
    
    weak var background: CCNode!

    
    func didLoadFromCCB(){

        gamePhysicsNode.collisionDelegate = self
        userInteractionEnabled = true
        multipleTouchEnabled = true
        gamePhysicsNode.debugDraw = true
        
        callT.exclusiveTouch = false
        callR.exclusiveTouch = false
        callC.exclusiveTouch = false
        heroP.exclusiveTouch = false
        if defaults.boolForKey("fromLevels"){
            var episode = defaults.integerForKey("currentEpisode")
            var number = defaults.integerForKey("levelButton")
            currentLevel = episode + number
        } else {
            currentLevel = defaults.integerForKey("level")
            println(currentLevel)
        }
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
        if barExist && differenceX != nil {
            moveCharacter(differenceX)
        } else {
        self.hero.physicsBody.velocity.x = 0.98 * hero.physicsBody.velocity.x
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
            
            differenceX = currentPositionX! - xTouchL!
            
//            if currentPositionX < screenHalf {
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
//            } else {
                touchMovedRight = true
//            }
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
        println(power)
        if power > 0 {
        if heroType == .Circle  {
            hero.physicsBody.eachCollisionPair { (pair) -> Void in
                if !self.hero.jumped {
                    self.hero.physicsBody.applyImpulse(CGPoint(x: 0, y: 180))
                    self.hero.jumped = true
                    self.reducePower(self.powerC)
                    NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: Selector("resetJump"), userInfo: nil, repeats: false)
                }


            }
        }
        if heroType == .Triangle {
            
            reducePower(powerT)
            hero.physicsBody.velocity.y = CGFloat(100)
        }
        if heroType == .Rectangle {
            reducePower(powerR)
            hero.physicsBody.velocity.y = CGFloat(0)
            hero.physicsBody.affectedByGravity = false
            println(hero.physicsBody.affectedByGravity)
        }
        }
        
    }
    
    func reducePower(reducePower: Float ){
        if power - reducePower >= 0 {
            power -= reducePower
        }
        else { power = 0}
    }
    
    func resetJump() {
        hero.jumped = false
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
            hero = CCBReader.load("Rectangle") as! Character
        }
        
        hero.position = heroPosition
        hero.physicsBody.velocity = heroVelocity
        gamePhysicsNode.addChild(hero)
        followHero()
    }
    
    func moveCharacter(velocity: CGFloat){
        
        if abs(differenceX) < hero.maxSpeed {
            hero.physicsBody.velocity.x = 1.2 * velocity
        } else {
            var sign = differenceX / abs(differenceX)
            hero.physicsBody.velocity.x = 1.2 * sign * hero.maxSpeed
        }

    }
    
    func loadLevel(){
        
//        power = 10
        levelNode.removeAllChildren()
        
        let level = CCBReader.load("Levels/Level\(currentLevel)") as! Level
        // Charge the characteristics about how the characters spend the power from the level
        powerT = level.powerT
        powerR = level.powerR
        powerC = level.powerC
        // Amount of mushrooms in each level
        mushrooms = level.mushroom
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
        if defaults.boolForKey("presentMap") {
            map()
            animationManager.runAnimationsForSequenceNamed("TimeF")
        }
    }
    
    func menu(){
        
        paused = true
        
        if mapExist {
            if firstTime{
                animationManager.runAnimationsForSequenceNamed("MenuB")
                background.opacity = 1
                firstTime = false
            }
            followHero()
            gamePhysicsNode.scale = 1
            mapExist = false
            aftermenu()
            return
            
        }
        
        if menuScene != nil {
            background.opacity = 1
            aftermenu()
            menuPosition.removeChild(menuScene)
            return
        }
        unableButtons()
        userInteractionEnabled = false
        menuScene = CCBReader.load("Menuscene", owner: self) as CCNode!

//        menuScene!.positionType = CCPositionType(xUnit: .Normalized, yUnit: .Normalized, corner: .BottomLeft)
//        menuScene!.position = CGPoint(x: 0.5, y: 0.5)
        menuPosition.addChild(menuScene)
        background.opacity = 0.5
        menuR.title = "continue"

 
    }
    
    func restart(){
        defaults.setBool(false, forKey: "presentMap")
        presentGamePlay()
    }
    
    func followHero() {
        follow = CCActionFollow(target: hero, worldBoundary: levelNode.boundingBox())
        gamePhysicsNode.position = follow!.currentOffset()
        gamePhysicsNode.runAction(follow)
    }
    
    // When the level finish because the player completed the level
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, hero: CCNode!, door: CCNode!) -> ObjCBool {
        
        if mushrooms == 0 {
            paused = true
            currentLevel++
            defaults.setInteger( currentLevel, forKey: "level")
            println(defaults.integerForKey("level"))
            
            if currentLevel > defaults.integerForKey("bestLevel"){
                defaults.setInteger(currentLevel, forKey: "bestLevel")
            }
            
            if defaults.boolForKey("fromLevels"){
                Gameplay().defaults.setBool(false, forKey: "fromLevels")

            }
            defaults.setBool(true, forKey: "presentMap")
            defaults.setFloat(power, forKey: "level\(currentLevel)")
            
            let win = CCBReader.loadAsScene("Win")
            let transition = CCTransition(fadeWithDuration: 0.8)
            CCDirector.sharedDirector().presentScene(win, withTransition: transition)
        }
        return true

    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, hero: CCNode!, mushroom: CCNode!) -> ObjCBool {
        if mushroom != nil {
            mushroom.removeFromParent()
            mushrooms--
        }
        return true
        
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, hero: CCNode!, plantJump: CCNode!) -> ObjCBool {
        self.hero.physicsBody.applyImpulse(CGPoint(x: 0, y: 350))
        return true
        
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, hero: CCNode!, mouth: CCNode!) -> ObjCBool {
        restart()
        return true
        
    }
    
    func map() {
        background.opacity = 1
        userInteractionEnabled = false
        gamePhysicsNode.position = CGPoint.zeroPoint
        paused = true
        gamePhysicsNode.scale = scaleH
        menuPosition.removeChild(menuScene)
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
    
    func presentGamePlay(){
        let level = CCBReader.loadAsScene("Gameplay")
        let transition = CCTransition(fadeWithDuration: 0.8)
        CCDirector.sharedDirector().presentScene(level, withTransition: transition)
    }
    
    func testing(){
        defaults.setInteger( 1, forKey: "level")
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "firstTime")
        presentGamePlay()
    }
    
    func mainMenu(){
        let level = CCBReader.loadAsScene("Episodes")
        let transition = CCTransition(fadeWithDuration: 0.8)
        CCDirector.sharedDirector().presentScene(level, withTransition: transition)
    }
    
}
