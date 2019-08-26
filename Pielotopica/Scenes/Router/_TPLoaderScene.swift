//
//  _TPLoaderScene.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/26.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

class _TPLoaderScene: SKScene {
    private let center = SKSpriteNode(imageNamed: "TP_loader_center")
    private let roter1 = SKSpriteNode(imageNamed: "TP_loader_router1")
    private let roter2 = SKSpriteNode(imageNamed: "TP_loader_router2")
    private let roter3 = SKSpriteNode(imageNamed: "TP_loader_router3")
    
    func start() {
        roter1.setScale(0)
        roter2.setScale(0)
        roter3.setScale(0)

        let a_s = SKAction.scale(to: 1, duration: 0.2).setEase(.easeInEaseOut)
        roter1.run(a_s, withKey: "scale")
        roter2.run(a_s, withKey: "scale")
        roter3.run(a_s, withKey: "scale")
    }
    
    func hideAll() {
        roter1.removeAction(forKey: "scale")
        roter2.removeAction(forKey: "scale")
        roter3.removeAction(forKey: "scale")
        
        let a_s = SKAction.scale(to: 0, duration: 0.2).setEase(.easeInEaseOut)
        roter1.run(a_s)
        roter2.run(a_s)
        roter3.run(a_s)
    }
    
    override func sceneDidLoad() {
        self.anchorPoint = [0.5, 0.5]
        roter1.run(.randomRotation(radians: 0.09, duration: 2.5))
        roter2.run(.randomRotation(radians: 0.06, duration: 3  ))
        roter3.run(.randomRotation(radians: 0.05, duration: 2  ))
            
        self.addChild(center)
        
        self.addChild(roter1)
        self.addChild(roter2)
        self.addChild(roter3)
            
        start()
    }
}

private extension SKAction {
    static func randomRotation(radians: CGFloat, duration: TimeInterval) -> SKAction {
        let firstAngle = CGFloat.random(in: 0...3.14)
        
        let a1 = SKAction.customAction(withDuration: duration, actionBlock: {node, time in
            let per = time / CGFloat(duration)
            let theta = firstAngle + CGFloat.pi*2*per
            
            let node = (node as! SKSpriteNode)
            node.anchorPoint = [0.5 + radians * cos(theta), 0.5 + radians * sin(theta)]
            
            node.zRotation = theta
        })
        
        return SKAction.repeatForever(a1)
    }
}
