//
//  TPBuildItemBar.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/22.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

class TPBuildItemBar: SKSpriteNode {
    private let inventory:TSItemBarInventory
    let backButton = TPFlatButton(textureNamed: "TP_flatbutton_back")
    let placeButton = TPDropButton(textureNamed: "TP_dropbutton_place")
    let moveButton = TPDropButton(textureNamed: "TP_dropbutton_move")
    let destoryButton = TPDropButton(textureNamed: "TP_dropbutton_destory")
    
    init(inventory:TSItemBarInventory) {
        self.inventory = inventory
        
        super.init(texture: .init(imageNamed: "TP_build_itembar_frame"), color: .clear, size: [312, 80])
        
        addChild(backButton)
        addChild(placeButton)
        addChild(moveButton)
        addChild(destoryButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
