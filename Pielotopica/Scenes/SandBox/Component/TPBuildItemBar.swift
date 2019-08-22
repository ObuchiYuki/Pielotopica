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
    
    private var allDropButtons:[SKSpriteNode] {
        return [placeButton, moveButton, destoryButton]
    }
    
    init(inventory:TSItemBarInventory) {
        self.inventory = inventory
        
        super.init(texture: .init(imageNamed: "TP_build_itembar_frame"), color: .clear, size: [312, 80])
        
        backButton.position = [0, 95]
        
        placeButton.position = [CGFloat(312 - 47 - 60 * 2 - 47.0/2), 95 + 47.0/2]
        moveButton.position = [CGFloat(312 - 47 - 60 - 47.0/2), 95 + 47.0/2]
        destoryButton.position = [CGFloat(312 - 47 - 47.0/2), 95 + 47.0/2]
        
        self.position = [-GKSafeScene.sceneSize.width / 2 + 30, -570]
        
        placeButton.isSelected = true
        
        placeButton.setScale(0)
        moveButton.setScale(0)
        destoryButton.setScale(0)
        
        addChild(backButton)
        addChild(placeButton)
        addChild(moveButton)
        addChild(destoryButton)
    }
    
    func show() {
        
        isHidden = false
        allDropButtons.enumerated().forEach{(arg) in
            let (i, e) = arg
            e.run(SKAction.sequence([
                SKAction.wait(forDuration: 0.1 * Double(i) + 0.3),
                SKAction.scale(to: 1, duration: 0.2)
            ]))
        }
        self.run(SKAction.moveTo(y: -340, duration: 0.3).setEase(.easeInEaseOut))
    }
    
    func hide() {
        self.run(
            SKAction.sequence([
                SKAction.moveTo(y: -570, duration: 0.3).setEase(.easeInEaseOut),
                SKAction.run {[weak self] in self?.isHidden = true }
            ])
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
