//
//  TPClearModal.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/01.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

class TPClearModal: SKSpriteNode {
    private let iron = TSClearModalMaterial(textureName: "TP_clear_wood_frame")
    private let wood = TSClearModalMaterial(textureName: "TP_clear_iron_frame")
    private let circit = TSClearModalMaterial(textureName: "TP_clear_circuit_frame")
    private let fuel = TSClearModalMaterial(textureName: "TP_clear_fuel_frame")
    
    private let scoreLabel = SKLabelNode(fontNamed: TPCommon.FontName.topica)
    
    let exitButton = GKButtonNode(
        size: [183, 28],
        defaultTexture: .init(imageNamed: "TP_clear_button_exit"),
        selectedTexture: .init(imageNamed: "TP_clear_button_exit_pressed"),
        disabledTexture: nil
    )
    
    private var allMaterials:[TSClearModalMaterial] {[iron, wood, circit, fuel]}
    
    init() {
        super.init(texture: .init(imageNamed: "TP_clear_modal_bacground"), color: .clear, size: [308, 418])
        
        self.position = [0, -30]
        
        scoreLabel.fontColor = TPCommon.Color.text
        scoreLabel.fontSize = 14
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = [ 95, -97]
        scoreLabel.run(.typewriter("1297192", withDuration: 0.5))
        
        self.addChild(scoreLabel)
        
        exitButton.position = [0, -137]
        
        
        self.addChild(exitButton)
        
        for (i, mat) in allMaterials.enumerated() {
            mat.position = [0, 115 - i.f * 48]
            
            self.addChild(mat)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
