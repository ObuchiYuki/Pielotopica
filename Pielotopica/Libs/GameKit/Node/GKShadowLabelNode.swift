//
//  GKShadowLabelNode.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/22.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

class GKShadowLabelNode: SKLabelNode {
    private let shadowLabel = SKLabelNode()
    
    override var text: String? {
        set{
            super.text = newValue
            shadowLabel.text = newValue
        }
        get{return super.text}
    }
    
    func barnShadow() {
        shadowLabel.fontSize = self.fontSize
        shadowLabel.fontName = self.fontName
        shadowLabel.fontColor = UIColor.black
        shadowLabel.horizontalAlignmentMode = self.horizontalAlignmentMode
        shadowLabel.verticalAlignmentMode = self.verticalAlignmentMode
        
        shadowLabel.text = self.text
        shadowLabel.zPosition = self.zPosition - 1
        shadowLabel.position = [1, -1]
        shadowLabel.alpha = 0.8
        
        self.addChild(shadowLabel)
    }
}
