//
//  _TPCaptureMaterialSprite.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/26.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

class _TPCaptureMaterialSprite: SKSpriteNode {
    init(textureNamed name:String) {
        super.init(texture: .init(imageNamed: name), color: .clear, size: [78, 20])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
