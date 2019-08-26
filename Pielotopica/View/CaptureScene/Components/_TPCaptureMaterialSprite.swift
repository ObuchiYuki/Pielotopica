//
//  _TPCaptureMaterialSprite.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/26.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

class _TPCaptureMaterialSprite: SKSpriteNode {
    private let icon:SKSpriteNode
    private let label = SKLabelNode(fontNamed: TPCommon.FontName.topica)
    
    func setCount(_ count:Int) {
        self.label.text = "x \(count)"
    }
    
    init(textureNamed name:String) {
        icon = SKSpriteNode(imageNamed: name)
        
        super.init(texture: nil, color: .clear, size: [78, 20])
        
        icon.anchorPoint = [0, 0.5]
        icon.position = [-39, 0]
        
        label.fontSize = 15
        label.fontColor = TPCommon.Color.text
        label.horizontalAlignmentMode = .right
        label.position = [39, -4]
        
        self.addChild(icon)
        self.addChild(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
