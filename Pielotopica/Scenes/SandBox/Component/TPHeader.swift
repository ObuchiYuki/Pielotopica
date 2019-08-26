//
//  TPHeader.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/21.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit
import RxSwift

class TPHeader: GKSpriteNode {
    let helthSlider = TPHeaderSlider(color: .init(hex: 0xCC4E4C), width: 105)
    let oilSlider = TPHeaderSlider(color: .init(hex: 0x3BA99E), width: 158)
    
    private let bag = DisposeBag()
    
    private func setIronAmount(_ amount:Int) {
        ironAmountLabel.run(SKAction.numberChanging(from: ironAmount, to: amount, postfix: " x", withDuration: 1))
        ironAmount = amount
    }
    private func setWoodAmount(_ amount:Int) {
        woodAmountLabel.run(SKAction.numberChanging(from: woodAmount, to: amount, postfix: " x", withDuration: 1))
        woodAmount = amount
    }
    private func setCircitAmount(_ amount:Int) {
        circitAmountLabel.run(SKAction.numberChanging(from: circitAmount, to: amount, postfix: " x", withDuration: 1))
        circitAmount = amount
    }
    
    private var ironAmount:Int = 0
    private var woodAmount:Int = 0
    private var circitAmount:Int = 0
    
    private let ironAmountLabel = GKShadowLabelNode(fontNamed: TPCommon.FontName.topica)
    private let woodAmountLabel = GKShadowLabelNode(fontNamed: TPCommon.FontName.topica)
    private let circitAmountLabel = GKShadowLabelNode(fontNamed: TPCommon.FontName.topica)
    
    private let dayLabel = SKLabelNode()
    
    init(){
        super.init(texture: .init(imageNamed: "TP_hd_background"), color: .clear, size: [354, 101])
        
        // rx
        TSMaterialData.shared.ironAmount.subscribe{ event in
            event.element.map(self.setIronAmount)
        }.disposed(by: bag)
        
        TSMaterialData.shared.woodAmount.subscribe{ event in
            event.element.map(self.setWoodAmount)
        }.disposed(by: bag)
        
        TSMaterialData.shared.circitAmount.subscribe{ event in
            event.element.map(self.setCircitAmount)
        }.disposed(by: bag)
        
        // node
        self.position = [-GKSafeScene.sceneSize.width / 2 + 10, GKSafeScene.sceneSize.height / 2 - 110]
        
        helthSlider.position = [51, 67]
        helthSlider.zPosition = self.zPosition - 1
        oilSlider.position = [51, 43]
        oilSlider.zPosition = self.zPosition - 1
        
        self.addChild(helthSlider)
        self.addChild(oilSlider)
        
        for (i, label) in [ironAmountLabel, woodAmountLabel, circitAmountLabel].enumerated() {
            setLabel(with: label, at: i)
        }
    }
    
    private func setLabel(with labelNode:GKShadowLabelNode, at index:Int) {
        labelNode.horizontalAlignmentMode = .right
        labelNode.fontSize = 13
        labelNode.position = [GKSafeScene.sceneSize.width - 70, 36 + 21 * CGFloat(index)]
        
        labelNode.barnShadow()
        
        self.addChild(labelNode)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
