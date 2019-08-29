//
//  TPMainMenuItem.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/21.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

class TPMainMenuItem: GKButtonNode {
    init(textureNamed textureName: String) {
        
        super.init(
            size: [76, 76],
            defaultTexture: .init(imageNamed: textureName),
            selectedTexture: .init(imageNamed: textureName+"_pressed"),
            disabledTexture: nil
        )
        
        self.anchorPoint = .zero
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
