//
//  TPCraftMenu.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/27.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

class TPCraftMenu: SKSpriteNode {
    override var needsHandleReaction: Bool { true }
    
    func setItem(_ item:TSItem) {
        self.nameLabel.text = item.name
        self.icon.texture = item.itemImage.map(SKTexture.init(image: ))
        
    }
    
    private let nameLabel = SKLabelNode()
    private let craftButton = TPFlatButton(textureNamed: "TP_flatbutton_craft")
    private let icon = SKSpriteNode(color: .clear, size: [50, 50])
    
    init() {
        super.init(texture: .init(imageNamed: "TP_craft_menu_background"), color: .clear, size: [305, 170])
        
        nameLabel.fontSize = 12
        nameLabel.fontName = TPCommon.FontName.hiraBold
        nameLabel.fontColor = TPCommon.Color.text
        nameLabel.horizontalAlignmentMode = .left
        nameLabel.position = [-130, 50]
        
        craftButton.position = [0, -60]
        icon.position = [-97, 0]
        
        self.addChild(nameLabel)
        self.addChild(craftButton)
        self.addChild(icon)
        
        self.zPosition = 100
        
        setItem(.japaneseHouse2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
