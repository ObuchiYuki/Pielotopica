//
//  GKTransitionNode.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/28.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

class GKTransitionNode: SKSpriteNode {
    let sprites = [SKSpriteNode]()
    
    init(size:CGSize) {
        super.init(texture: nil, color: .red, size: size)
        self.zPosition = 1000
        
    }
    
    required init?(coder: NSCoder) {fatalError()}
    
    func show(_ completion: @escaping ()->Void) {
        for y in 0..<10 {
            for x in 0..<10 {
                let sprite = SKShapeNode(rectOf: [10, 10])
                sprite.fillColor = .green
                sprite.zRotation = .pi/4
                sprite.position = [CGFloat(x) * 10, CGFloat(y) * 10]
                sprite.setScale(0)
                
                self.addChild(sprite)
                
                sprite.run(
                    SKAction.sequence([
                        .wait(forDuration: Double(y) * 1),
                        .scale(to: 1, duration: 10)
                    ])
                )
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+10, execute: {
            completion()
        })
    }
}
