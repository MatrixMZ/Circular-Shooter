//
//  GameScene.swift
//  Circular Shooter
//
//  Created by Mateusz Ziobrowski on 24/07/2019.
//  Copyright © 2019 Mateusz Ziobrowski. All rights reserved.
//

import SpriteKit

struct PhysicsCategory {
    static let Enemy: UInt32 = 0x1 << 0
    static let SmallBall: UInt32 = 0x1 << 1
    static let MainBall: UInt32 = 0x1 << 2
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var MainBall = SKSpriteNode(imageNamed: "Ball")
    var EnemyTimer = Timer()
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        MainBall.size = CGSize(width: 100, height: 100)
        MainBall.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        MainBall.color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        MainBall.colorBlendFactor = 1.0
        MainBall.zPosition = 1.0
        
        MainBall.physicsBody = SKPhysicsBody(circleOfRadius: MainBall.size.width / 2)
        MainBall.physicsBody?.categoryBitMask = PhysicsCategory.MainBall
        MainBall.physicsBody?.collisionBitMask = PhysicsCategory.Enemy
        MainBall.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
        MainBall.physicsBody?.affectedByGravity = false
        MainBall.physicsBody?.isDynamic = false
        MainBall.name = "MainBall"
        
        self.addChild(MainBall)
        
//        EnemyTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector:  #selector(self.Enemies), userInfo: nil, repeats: true)
        EnemyTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { (timer) in
            self.Enemies()
        })
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA.node as! SKSpriteNode
        let secondBody = contact.bodyB.node as! SKSpriteNode
        
        if firstBody.name == "Enemy" && secondBody.name == "SmallBall"   {
            collisionBullet(Enemy: firstBody, SmallBall: secondBody)
        } else if firstBody.name == "SmallBall" && secondBody.name == "Enemy" {
            collisionBullet(Enemy: secondBody, SmallBall: firstBody)
        }
        
        if firstBody.name == "MainBall" && secondBody.name == "Enemy"  {
            
        } else if  firstBody.name == "Enemy" && secondBody.name == "MainBall"  {
            
        }
        
    }
    
    func collisionBullet(Enemy: SKSpriteNode, SmallBall: SKSpriteNode) {
        Enemy.physicsBody?.isDynamic = true
        Enemy.physicsBody?.affectedByGravity = true
        Enemy.physicsBody?.mass = 5.0
        
        SmallBall.physicsBody?.mass = 5.0
        
        Enemy.removeAllActions()
        SmallBall.removeAllActions()
    }
    
    
    func touchDown(atPoint pos : CGPoint) {

    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            let SmallBall = SKSpriteNode(imageNamed: "Ball")
            SmallBall.position = MainBall.position
            SmallBall.size = CGSize(width: 30, height: 30)
            SmallBall.physicsBody = SKPhysicsBody(circleOfRadius: SmallBall.size.width / 2)
            SmallBall.color = #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)
            SmallBall.colorBlendFactor = 1.0
            SmallBall.physicsBody?.categoryBitMask = PhysicsCategory.SmallBall
            SmallBall.physicsBody?.collisionBitMask = PhysicsCategory.Enemy
            SmallBall.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
            SmallBall.name = "SmallBall"
            SmallBall.physicsBody?.isDynamic = true
            SmallBall.physicsBody?.affectedByGravity = true
            
            
            self.addChild(SmallBall)
            
            var dx = CGFloat(location.x - MainBall.position.x)
            var dy = CGFloat(location.y - MainBall.position.y)
            
            let magnitude = sqrt(dx * dx + dy * dy)
            
            dx /= magnitude
            dy /= magnitude
            
            let vecotr = CGVector(dx: 30 * dx, dy: 30 * dy)
            
            SmallBall.physicsBody?.applyImpulse(vecotr)
        }
    }
    
   func Enemies() {
        let Enemy = SKSpriteNode(imageNamed: "Ball")
        
        Enemy.size = CGSize(width: 20, height: 20)
        Enemy.color = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        Enemy.colorBlendFactor = 1.0
    
        Enemy.physicsBody = SKPhysicsBody(circleOfRadius: Enemy.size.width / 2)
        Enemy.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        Enemy.physicsBody?.contactTestBitMask = PhysicsCategory.SmallBall | PhysicsCategory.MainBall
        Enemy.physicsBody?.collisionBitMask = PhysicsCategory.SmallBall | PhysicsCategory.MainBall
        Enemy.physicsBody?.isDynamic = false
        Enemy.name = "Enemy"
    
        
        let edgeOfScreen = arc4random() % 4
        
        switch edgeOfScreen {
            case 0:  // LEFT edge
                Enemy.position.x = 0
                Enemy.position.y = CGFloat(arc4random_uniform(UInt32(frame.size.height)))
                break
            case 1: // RIGHT edge
                Enemy.position.x = CGFloat(frame.size.width)
                Enemy.position.y = CGFloat(arc4random_uniform(UInt32(frame.size.height)))
                break
            case 2:  // TOP edge
                Enemy.position.x = CGFloat(arc4random_uniform(UInt32(frame.size.width)))
                Enemy.position.y = 0
                break
            case 3:  // BOTTOM edge
                Enemy.position.x = CGFloat(arc4random_uniform(UInt32(frame.size.width)))
                Enemy.position.y = CGFloat(frame.size.height)
                break
            default:
                break
        }
    
        self.addChild(Enemy)
    
        Enemy.run(SKAction.move(to: MainBall.position, duration: 3))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
       
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
       
    }
    
    
    override func update(_ currentTime: TimeInterval) {
       
    }
}
