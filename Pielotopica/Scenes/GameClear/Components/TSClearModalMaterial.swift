//
//  TSClearModalMaterial.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/01.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

class TSClearModalMaterial: SKSpriteNode {
    init(textureName:String) {
        super.init(texture: .init(imageNamed: textureName), color: .clear, size: [197, 24])
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
