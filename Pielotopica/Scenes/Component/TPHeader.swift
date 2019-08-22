//
//  TPHeader.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/21.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

class TPHeader: GKSpriteNode {
    let helthSlider = TPHeaderSlider(color: .init(hex: 0xCC4E4C), width: 105)
    let oilSlider = TPHeaderSlider(color: .init(hex: 0x3BA99E), width: 158)
    
    private let ironAmountLabel = GKShadowLabelNode(fontNamed: TPCommon.FontName.topica)
    private let woodAmountLabel = GKShadowLabelNode(fontNamed: TPCommon.FontName.topica)
    private let circitAmountLabel = GKShadowLabelNode(fontNamed: TPCommon.FontName.topica)
    private let paperAmountLabel = GKShadowLabelNode(fontNamed: TPCommon.FontName.topica)
    
    init(){
        super.init(texture: .init(imageNamed: "TP_hd_background"), color: .clear, size: [354, 119])
        
        self.position = [-GKSafeScene.sceneSize.width / 2 + 10, GKSafeScene.sceneSize.height / 2 - 130]
        
        helthSlider.position = [51, 83]
        oilSlider.position = [51, 59]
        
        self.addChild(helthSlider)
        self.addChild(oilSlider)
        
        for (i, label) in [ironAmountLabel, woodAmountLabel, circitAmountLabel, paperAmountLabel].enumerated() {
            setLabel(with: label, at: i)
        }
    }
    
    private func setLabel(with labelNode:GKShadowLabelNode, at index:Int) {
        labelNode.horizontalAlignmentMode = .right
        labelNode.fontSize = 13
        labelNode.position = [GKSafeScene.sceneSize.width - 70, 33 + 21 * CGFloat(index)]
        labelNode.text = "12 x"
        
        labelNode.barnShadow()
        
        self.addChild(labelNode)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
