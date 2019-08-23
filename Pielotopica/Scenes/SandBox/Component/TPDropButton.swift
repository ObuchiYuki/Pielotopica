//
//  TPDropButton.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/22.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

class TPDropButton: GKButtonNode {
    var selectionState = true {
        didSet {
            isSelected = self.selectionState
        }
    }
    
    init(textureNamed name:String) {
        super.init(
            size: [47, 47],
            defaultTexture: .init(imageNamed: name),
            selectedTexture: .init(imageNamed: name+"_pressed"),
            disabledTexture: nil
        )
        
    }
    
    override func buttonDidSelect() {
        self.isSelected = selectionState
    }
    override func buttonDidUnselect() {
        RMTapticEngine.impact.feedback(.medium)
        
        self.isSelected = selectionState
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
