//
//  GKSpriteNode.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/22.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

class GKSpriteNode: SKSpriteNode {
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
        self.anchorPoint = .zero
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
