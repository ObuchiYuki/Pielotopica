//
//  TPGameOverModal.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/01.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

class TPGameOverModal: SKSpriteNode {
    private let iron = TSClearModalMaterial(textureName: "TP_clear_wood_frame", gameovered: true)
    private let wood = TSClearModalMaterial(textureName: "TP_clear_iron_frame", gameovered: true)
    private let circit = TSClearModalMaterial(textureName: "TP_clear_circuit_frame", gameovered: true)
    private let fuel = TSClearModalMaterial(textureName: "TP_clear_fuel_frame", gameovered: true)
        
    let exitButton = GKButtonNode(
        size: [183, 28],
        defaultTexture: .init(imageNamed: "TP_clear_button_exit"),
        selectedTexture: .init(imageNamed: "TP_clear_button_exit_pressed"),
        disabledTexture: nil
    )
    
    func load(_ gameEndData:TPGameEndData) {
        let award = gameEndData.award
        let mdata = TSMaterialData.shared
        let fdata = TSFuelData.shared
        
        iron.setAmount(award.iron, total: mdata.ironAmount.value - award.iron, gameovered: true)
        wood.setAmount(award.wood, total: mdata.woodAmount.value - award.wood, gameovered: true)
        circit.setAmount(award.circit, total: mdata.circitAmount.value - award.circit, gameovered: true)
        fuel.setAmount(award.fuel, total: fdata.fuel.value - award.fuel, gameovered: true)
    }
    
    private var allMaterials:[TSClearModalMaterial] {[iron, wood, circit, fuel]}
    
    init() {
        super.init(texture: .init(imageNamed: "TP_gameover_modal_bacground"), color: .clear, size: [308, 418])
        
        self.position = [0, -30]
        
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
