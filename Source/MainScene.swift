import Foundation

class MainScene: CCNode {
    
    override func update(delta: CCTime) {
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "presentMap")
        if NSUserDefaults.standardUserDefaults().boolForKey("firstTime"){
            let level = CCBReader.loadAsScene("Menu")
            let transition = CCTransition(fadeWithDuration: 1.2)
            CCDirector.sharedDirector().presentScene(level, withTransition: transition)
            
        } else {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "firstTime")
            let level = CCBReader.loadAsScene("MenuFirstTime")
            let transition = CCTransition(fadeWithDuration: 1.2)
            CCDirector.sharedDirector().presentScene(level, withTransition: transition)
        }

    }
    
//    func startGame(){
//        NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "level")
//        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "presentMap")
//        let level = CCBReader.loadAsScene("Gameplay")
//        let transition = CCTransition(fadeWithDuration: 0.8)
//        CCDirector.sharedDirector().presentScene(level, withTransition: transition)
//    }

}
