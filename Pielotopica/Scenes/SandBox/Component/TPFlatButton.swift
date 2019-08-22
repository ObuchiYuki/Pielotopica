//
//  TPFlatButton.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/22.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

class TPFlatButton: GKButtonNode {
    init(textureNamed name:String) {
        super.init(
            size: [75, 26],
            defaultTexture: .init(imageNamed: name),
            selectedTexture: .init(imageNamed: name+"_pressed"),
            disabledTexture: nil
        )
        
        self.anchorPoint = .zero
    }
    
    override func buttonDidUnselect() {
        RMTapticEngine.impact.feedback(.medium)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
