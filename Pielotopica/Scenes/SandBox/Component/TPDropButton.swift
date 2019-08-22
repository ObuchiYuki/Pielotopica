//
//  TPDropButton.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/22.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

class TPDropButton: GKButtonNode {
    init(textureNamed name:String) {
        super.init(
            size: [47, 47],
            defaultTexture: .init(imageNamed: name),
            selectedTexture: .init(imageNamed: name+"_pressed"),
            disabledTexture: nil
        )
        
    }
    
    override func buttonDidUnselect() {
        RMTapticEngine.impact.feedback(.medium)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
