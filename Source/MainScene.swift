import Foundation

class MainScene: CCNode {
    
    func startGame(){
        let level = CCBReader.loadAsScene("Gameplay")
        let transition = CCTransition(fadeWithDuration: 0.8)
        CCDirector.sharedDirector().presentScene(level)
    }

}
