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
    
    weak var selector: CCNode!
    
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
    
    // Testinf the level of energy for each character
    
    var energyC = 0
    
    var energyT = 0
    
    var energyR = 0
    
    weak var powerScreenR: CCNode!
    weak var powerScreenT: CCNode!
    weak var powerScreenC: CCNode!
    
    weak var menuP: CCNode!
    weak var menuT: CCNode!
    
    var time = 0
    
    var powerRectangle: Float = 10 {
        didSet {
            powerScreenR.scaleX = powerRectangle / Float(10)
        }
    }
    
    var powerTriangle: Float = 10 {
        didSet {
            powerScreenT.scaleX = powerTriangle / Float(10)
        }
    }
    
    var powerCircle: Float = 10 {
        didSet {
            powerScreenC.scaleX = powerCircle / Float(10)
        }
    }
    
    func didLoadFromCCB(){

        gamePhysicsNode.collisionDelegate = self
        userInteractionEnabled = true
        multipleTouchEnabled = true
//        gamePhysicsNode.debugDraw = true
        
        callT.exclusiveTouch = false
        callR.exclusiveTouch = false
        callC.exclusiveTouch = false
        heroP.exclusiveTouch = false
        if defaults.boolForKey("fromLevels"){
            defaults.setBool(false, forKey: "fromLevels")
            currentLevel = Gameplay().defaults.integerForKey("levelButton")
        } else {
            currentLevel = defaults.integerForKey("level")
            
        }
        
        loadLevel()
    }
    
    override func update(delta: CCTime) {
        println(defaults.boolForKey("tutorial\(currentLevel + 1)"))
        if defaults.boolForKey("tutorial\(currentLevel + 1)"){
            animationManager.runAnimationsForSequenceNamed("Tutorial\(currentLevel + 1)")
            defaults.setBool(false, forKey: "tutorial\(currentLevel + 1)")
        }


        if heroP.touchInside{
            heroPower()
            if self.hero.physicsBody.velocity.y > 0 && heroType == .Triangle{
                self.hero.physicsBody.velocity.y *= 0.9
            }
        } else {
            hero.physicsBody.affectedByGravity = true
        }
        
        if CGRectGetMaxY(hero.boundingBox()) < CGRectGetMinY(gamePhysicsNode.boundingBox()) {
//            if heroType == .Circle {
//                hero.death()
//                self.scheduleOnce("restart", delay: 1.0 )
//                return
//            }
            restart()
        }
        if barExist && differenceX != nil {
            moveCharacter(differenceX)
        } else {
        self.hero.physicsBody.velocity.x *= 0.98
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
     
        currentPositionX = touch.locationInWorld().x
        currentPositionY = touch.locationInWorld().y
        println(currentPositionX)
        touchMovedRight = false
        
        hero.walking()
        

        
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
        hero.hi = false
        
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
        if heroType == .Circle  {
            if powerCircle > 0 {
                hero.physicsBody.eachCollisionPair { (pair) -> Void in
                    if !self.hero.jumped {
                        self.hero.jumping()
                        self.energyC++
                        self.hero.physicsBody.applyImpulse(CGPoint(x: 0, y: 180))
                        self.hero.jumped = true
                        self.reducePowerC(self.powerC)
                        NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: Selector("resetJump"), userInfo: nil, repeats: false)
                    }
                }
            }
        }
            
        if heroType == .Triangle {
            self.hero.jumping()
            if powerTriangle > 0 {
                reducePowerT(powerT)
                hero.physicsBody.velocity.y = CGFloat(100)
                energyT++
            }
        }
        if heroType == .Rectangle {
            self.hero.jumping()
            if powerRectangle > 0 {
                reducePowerR(powerR)
                hero.physicsBody.velocity.y = CGFloat(0)
                hero.physicsBody.affectedByGravity = false
                println(hero.physicsBody.affectedByGravity)
                energyR++
            }
        }
        
        
    }
    
    func reducePower(reducePower: Float){
        if power - reducePower >= 0 {
            power -= reducePower
        }
        else { power = 0}
    }
    
    func reducePowerT(reducePower: Float){
        if powerTriangle - reducePower >= 0 {
            powerTriangle -= reducePower
            power = powerTriangle
        }
        else { powerTriangle = 0
        power = powerTriangle}
    }
    func reducePowerR(reducePower: Float){
        if powerRectangle - reducePower >= 0 {
            powerRectangle -= reducePower
            power = powerRectangle
        }
        else { powerRectangle = 0
            power = powerRectangle
        }
    }
    func reducePowerC(reducePower: Float){
        if powerCircle - reducePower >= 0 {
            powerCircle -= reducePower
            power = powerCircle
        }
        else { powerCircle = 0
            power = powerCircle
        }
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
            power = powerCircle
        } else if heroType == .Triangle {
            hero = CCBReader.load("Triangle") as! Character
            power = powerTriangle
        } else {
            hero = CCBReader.load("Rectangle") as! Character
            power = powerRectangle
        }
        
        hero.position = heroPosition
        hero.physicsBody.velocity = heroVelocity
        gamePhysicsNode.addChild(hero)
        followHero()
    }
    
    func moveCharacter(velocity: CGFloat){
        var sign = differenceX / abs(differenceX)
        if sign < 0 {
            hero.flipL()
        } else {
            hero.flipR()
        }
        if abs(differenceX) < hero.maxSpeed {
            hero.physicsBody.velocity.x = 1.2 * velocity
        } else {
            hero.physicsBody.velocity.x = 1.2 * sign * hero.maxSpeed
        }

    }
    
    func loadLevel(){
        
        println(currentLevel)
        let level = CCBReader.load("Levels/Level\(currentLevel)") as! Level
        // Charge the characteristics about how the characters spend the power from the level
        powerT = level.powerT
        powerR = level.powerR
        powerC = level.powerC
        // Amount of mushrooms in each level
        mushrooms = level.mushroom
        // Doing the level size equal to gamePhysicsNode size
        gamePhysicsNode.contentSize = level.contentSize
        defaults.setFloat(level.toGet2, forKey: "toGet2")
        defaults.setFloat(level.toGet3, forKey: "toGet3")

        scaleH = Float(CCDirector.sharedDirector().viewSize().height / level.contentSize.height)
        
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
//            animationManager.runAnimationsForSequenceNamed("TimeF")
            menuP.visible = true
            menuT.visible = false
        }
    }
    
    func menu(){
        
        paused = true
        if defaults.boolForKey("tutorial1"){
            defaults.setBool(false, forKey: "tutorial1")
        }
        if mapExist {
            if firstTime{
                menuP.visible = false
                menuT.visible = true
                background.opacity = 1
                firstTime = false
            }
            self.selector.visible = true
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
        menuT.visible = false
        menuP.visible = true
 
    }
    
    func restart(){
        defaults.setBool(false, forKey: "presentMap")
        defaults.setInteger(currentLevel, forKey: "level")
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
            println("energyR")
            println(energyR)
            println("energyC")
            println(energyC)
            println("energyT")
            println(energyT)
            
            paused = true
            currentLevel++
            defaults.setInteger( currentLevel, forKey: "level")
            println(defaults.integerForKey("level"))
            
            if currentLevel > defaults.integerForKey("bestLevel"){
                defaults.setInteger(currentLevel, forKey: "bestLevel")
                defaults.setBool(true, forKey: "showbutton\(currentLevel)")
            }
            
            if defaults.boolForKey("fromLevels"){
                Gameplay().defaults.setBool(false, forKey: "fromLevels")

            }
            defaults.setBool(true, forKey: "presentMap")
            defaults.setFloat(powerRectangle + powerTriangle + powerCircle, forKey: "level\(currentLevel)")
            
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
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, hero: CCNode!, die: CCNode!) -> ObjCBool {
        restart()
        return true
        
    }
    
    func map() {
        if defaults.boolForKey("tutorial1") {
            animationManager.runAnimationsForSequenceNamed("Tutorial1")
        }
        self.selector.visible = false
        background.opacity = 1
        userInteractionEnabled = false
        gamePhysicsNode.position = CGPoint.zeroPoint
        paused = true
        gamePhysicsNode.scale = scaleH
        menuPosition.removeChild(menuScene)
        mapExist = true
        menuT.visible = false
        menuP.visible = true
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
        menuT.visible = true
        menuP.visible = false
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
    
        
    func mainMenu(){
        let level = CCBReader.loadAsScene("Episodes")
        let transition = CCTransition(fadeWithDuration: 0.8)
        CCDirector.sharedDirector().presentScene(level, withTransition: transition)
    }
    
    func resetToDefaults(){
//        var dict = defaults.dictionaryRepresentation()
        defaults.removePersistentDomainForName(NSBundle.mainBundle().bundleIdentifier!)
        defaults.synchronize()
//        for (id,key) in dict {
//            println(key)
//            println(id)
//
//        }
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, hero: CCNode!, foliage: CCNode!) -> ObjCBool {
        hero.physicsBody.velocity = CGPoint(x: 0 , y: 0)
        hero.physicsBody.applyImpulse(CGPoint(x: 0,y: 200)) 
        if foliage != nil {
            foliage.removeFromParent()
        }
        return true
        
    }
}
