//
//  TSClearModalMaterial.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/01.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

class TSClearModalMaterial: SKSpriteNode {
    
    private let amountLabel = SKLabelNode(fontNamed: TPCommon.FontName.topica)
    private let totalAmountLabel = SKLabelNode(fontNamed: TPCommon.FontName.topica)
    
    func setAmount(_ amount:Int, total:Int, gameovered:Bool = false) {
        amountLabel.run(.numberChanging(from: 0, to: amount, prefix: gameovered ? "- " : "x ", withDuration: 2))
        totalAmountLabel.run(.numberChanging(from: 0, to: total,prefix: "Total x ", withDuration: 2))
    }
    
    init(textureName:String, gameovered:Bool) {
        super.init(texture: .init(imageNamed: textureName), color: .clear, size: [197, 24])
        
        amountLabel.position = [-15, -4]
        amountLabel.horizontalAlignmentMode = .right
        amountLabel.fontSize = 12
        amountLabel.fontColor = gameovered ? TPCommon.Color.dangerous : TPCommon.Color.text
                
        totalAmountLabel.position = [10 , -4]
        totalAmountLabel.horizontalAlignmentMode = .left
        totalAmountLabel.fontSize = 12
        totalAmountLabel.fontColor = gameovered ? TPCommon.Color.dangerous : TPCommon.Color.text
        
        self.addChild(amountLabel)
        self.addChild(totalAmountLabel)
    }
    
    private func _setupLabel() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
