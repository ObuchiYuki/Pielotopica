//
//  TPHeaderSlider.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/21.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

class TPHeaderSlider: GKSpriteNode {
    
    var maxValue:Double = 100 { didSet {_changeValue()} }
    var minValue:Double = 0 { didSet {_changeValue()} }
    var value:Double = 0 { didSet {_changeValue()} }
    
    private let valueLabel = SKLabelNode()
    private let selectedNode:SKSpriteNode
    
    private func _changeValue() {
        let ratio = (value - minValue) / (maxValue - minValue)
        let pwidth = self.size.width * CGFloat(ratio)
        
        selectedNode.run(.resize(toWidth: pwidth, duration: 0.3))
    }
    
    init(color:UIColor, width:CGFloat) {
        selectedNode = SKSpriteNode(color: color, size: [0, 13])
        
        super.init(texture: nil, color: UIColor.black.withAlphaComponent(0.3), size: [width, 13])
                
        valueLabel.text = "1212"
        valueLabel.fontName = TPCommon.FontName.topica
        valueLabel.fontColor = .white
        valueLabel.fontSize = 12
        valueLabel.horizontalAlignmentMode = .left
        valueLabel.position = [6, 1.5]
        
        selectedNode.anchorPoint = .zero
        
        self.addChild(selectedNode)
        self.addChild(valueLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
