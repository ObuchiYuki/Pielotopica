//
//  TPBuildItemBar.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/22.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

class TPBuildItemBar: GKSpriteNode {
    private let inventory:TSItemBarInventory
    let backButton = TPFlatButton(textureNamed: "TP_flatbutton_back")
    let placeButton = TPDropButton(textureNamed: "TP_dropbutton_place")
    let moveButton = TPDropButton(textureNamed: "TP_dropbutton_move")
    let destoryButton = TPDropButton(textureNamed: "TP_dropbutton_destory")
    
    init(inventory:TSItemBarInventory) {
        self.inventory = inventory
        
        super.init(texture: .init(imageNamed: "TP_build_itembar_frame"), color: .clear, size: [312, 80])
        
        backButton.position = [0, 95]
        
        placeButton.position = [CGFloat(312 - 47 - 60 * 2), 95]
        moveButton.position = [CGFloat(312 - 47 - 60), 95]
        destoryButton.position = [CGFloat(312 - 47), 95]
        
        self.position = [-GKSafeScene.sceneSize.width / 2 + 30, -570]
        
        placeButton.isSelected = true
        
        addChild(backButton)
        addChild(placeButton)
        addChild(moveButton)
        addChild(destoryButton)
    }
    
    func show() {
        
        self.run(.moveTo(y: -340, duration: 0.3))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
