//
//  TSE_DebugSprite.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/17.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

class TSE_DebugSprite: TSSprite {
    
}

private class DebugSprite: SKSpriteNode {
    let label = SKLabelNode()
    
    init() {
        super.init(texture: nil, color: .purple, size: [100, 30])
        
        label.fontSize = 16
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        
        label.fontColor = .white
        self.addChild(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
