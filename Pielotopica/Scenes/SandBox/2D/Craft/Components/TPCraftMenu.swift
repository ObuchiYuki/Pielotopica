//
//  TPCraftMenu.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/27.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

class TPCraftMenu: SKSpriteNode {
    // ===================================================================== //
    // MARK: - Properties -
    override var needsHandleReaction: Bool { true }
    
    let craftButton = TPFlatButton(textureNamed: "TP_flatbutton_craft", useDisable: true)
    
    private var selectedItem:TSItem = .none
    private let materials = TPCraftMenuMaterials()
    private let nameLabel = SKLabelNode()
    private let icon = SKSpriteNode(color: .clear, size: [50, 50])
    
    // ===================================================================== //
    // MARK: - Methods -
    func setItem(_ item:TSItem) {
        self.selectedItem = item
        
        if item == .none {
            self.nameLabel.text = ""
            self.icon.texture = nil
            self.materials.hide()
            
            _checkState()
            return
        }
        
        self.nameLabel.text = item.name
        self.icon.texture = item.itemImage.map(SKTexture.init(image: ))
        if let materials = item.materialsForCraft() {
            self.materials.show(value: materials)
        }
        
        _checkState()

    }
    // ===================================================================== //
    // MARK: - Private Methods -
    private func _checkState() {
        craftButton.isEnabled = _canCreateCurrentItem()
        
    }
    private func _canCreateCurrentItem() -> Bool {
        guard let material = selectedItem.materialsForCraft() else {return false}
        
        let mdata = TSMaterialData.shared
        let fdata = TSFuelData.shared
        
        let flag = material.iron > mdata.ironAmount.value &&
            material.wood > mdata.woodAmount.value &&
            material.circit > mdata.circitAmount.value &&
            material.fuel > fdata.fuel.value
        
        return flag
    }
    // ===================================================================== //
    // MARK: - Constructor -
    init() {
        super.init(texture: .init(imageNamed: "TP_craft_menu_background"), color: .clear, size: [305, 170])
        
        nameLabel.fontSize = 12
        nameLabel.fontName = TPCommon.FontName.hiraBold
        nameLabel.fontColor = TPCommon.Color.text
        nameLabel.horizontalAlignmentMode = .left
        nameLabel.position = [-128, 50]
        
        materials.position = [40, 22]
        craftButton.position = [0, -60]
        icon.position = [-97, 0]
        
        self.addChild(materials)
        self.addChild(nameLabel)
        self.addChild(craftButton)
        self.addChild(icon)
        
        self.zPosition = 100
        
        self.position = [0, 140]
    
        setItem(.none)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
