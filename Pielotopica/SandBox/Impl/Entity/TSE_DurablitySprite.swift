//
//  TSE_DurablitySprite.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/31.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

private class DurablitySprite: SKSpriteNode {
    
    var durablity:Int = 0 {didSet{_check()}}
    var maxDurablity:Int = 0 {didSet{_check()}}
    
    let colorNode:SKSpriteNode
    init(color:UIColor) {
        self.colorNode = SKSpriteNode(color: color, size: [100, 20])
        
        super.init(texture: nil, color: .lightGray, size: [100, 20])
        
        self.colorNode.anchorPoint = [0, 0.5]
        self.colorNode.position = [-50, 0]
        
        self.addChild(colorNode)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func _check() {
        let ratio = durablity / maxDurablity
        let pwidth = self.size.width * CGFloat(ratio)
        
        colorNode.run(.resize(toWidth: pwidth, duration: 0.3))
        
        colorNode.zPosition = 100
    }
}

class TSE_DurablitySprite: TSSprite {
    
    var durablity:Int {
        set {sprite.durablity = newValue}
        get {sprite.durablity}
    }
    
    private let sprite = DurablitySprite(color: .red)
    
    init(max:Int) {
        
        super.init(sprite: sprite)
        sprite.maxDurablity = max
        
    }
}
