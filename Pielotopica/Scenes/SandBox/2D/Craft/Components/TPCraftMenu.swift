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
    
    let craftButton = GKButtonNode(
        size: [99, 124],
        defaultTexture:  .init(imageNamed: "TP_craft_craft"),
        selectedTexture: .init(imageNamed: "TP_craft_craft_pressed"),
        disabledTexture: .init(imageNamed: "TP_craft_craft_disabled")
    )
    
    private var selectedItem:TSItem = .none
    private let amountLabel = SKLabelNode(fontNamed: TPCommon.FontName.topica)
    private let materials = TPCraftMenuMaterials()
    private let nameLabel = SKLabelNode()
    private let icon = SKSpriteNode(color: .clear, size: [50, 50])
    
    // ===================================================================== //
    // MARK: - Methods -
    func setItem(_ item:TSItem) {
        self.selectedItem = item
        
        if item == .none {
            self.nameLabel.text = ""
            self.amountLabel.text = ""
            self.icon.texture = nil
            self.materials.hide()
            
            checkState()
            return
        }
        
        self.amountLabel.text = "x \(item.amountCanCreateAtOnce())"
        self.nameLabel.text = item.name
        self.icon.texture = item.itemImage.map(SKTexture.init(image: ))
        
        checkState()

    }
    // ===================================================================== //
    // MARK: - Private Methods -
    func checkState() {
        let flag = _canCreateCurrentItem()
        
        craftButton.isEnabled = flag
        materials.alpha = flag ? 1 : 0.5
        
        if let materials = selectedItem.materialsForCraft() {
            self.materials.show(value: materials)
        }
    }
    private func _canCreateCurrentItem() -> Bool {
        guard let material = selectedItem.materialsForCraft() else {return false}
        
        let mdata = TSMaterialData.shared
        let fdata = TSFuelData.shared
        
        let flag = material.iron <= mdata.ironAmount.value &&
            material.wood <= mdata.woodAmount.value &&
            material.circit <= mdata.circitAmount.value &&
            material.fuel <= fdata.fuel.value
        
        return flag
    }
    // ===================================================================== //
    // MARK: - Constructor -
    init() {
        super.init(texture: .init(imageNamed: "TP_craft_menu_background"), color: .clear, size: [305, 170])
        
        amountLabel.fontSize = 14
        amountLabel.fontColor = TPCommon.Color.text
        amountLabel.horizontalAlignmentMode = .left
        amountLabel.position = [-55, -5]
        amountLabel.text = "x 1"
        
        nameLabel.fontSize = 12
        nameLabel.fontName = TPCommon.FontName.hiraBold
        nameLabel.fontColor = TPCommon.Color.text
        nameLabel.horizontalAlignmentMode = .left
        nameLabel.position = [-128, 50]
        
        materials.position = [60, -7]
        materials.zPosition = 5
        craftButton.position = [60, 0]
        icon.position = [-97, 0]
        
        self.addChild(materials)
        self.addChild(nameLabel)
        self.addChild(amountLabel)
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
