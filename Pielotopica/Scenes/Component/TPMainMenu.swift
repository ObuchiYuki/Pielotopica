//
//  TPMainMenu.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/21.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

/// Position -> settted
class TPMainMenu: SKSpriteNode {
    
    let menuItem = TPMainMenuItem(textureNamed: "TP_mm_menu")
    let buildItem = TPMainMenuItem(textureNamed: "TP_mm_build")
    let captureItem = TPMainMenuItem(textureNamed: "TP_mm_capture")
    let shopItem = TPMainMenuItem(textureNamed: "TP_mm_shop")
    
    init() {
        super.init(texture: nil, color: .clear, size: [328, 76])
        
        menuItem.anchorPoint = .zero
        buildItem.anchorPoint = .zero
        captureItem.anchorPoint = .zero
        shopItem.anchorPoint = .zero
        
        menuItem.position = [0, -180]
        buildItem.position = [CGFloat((76+8) * 1), -180]
        captureItem.position = [CGFloat((76+8) * 2), -180]
        shopItem.position = [CGFloat((76+8) * 3), -180]
        
        addChild(menuItem)
        addChild(buildItem)
        addChild(captureItem)
        addChild(shopItem)
        
        menuItem.run(_showAction(at: 0))
        buildItem.run(_showAction(at: 1))
        captureItem.run(_showAction(at: 2))
        shopItem.run(_showAction(at: 3))
        
        self.position = CGPoint(
            x: -GKSafeScene.sceneSize.width/2 + 23,
            y: -GKSafeScene.sceneSize.height/2 + 76/2
        )
        
    }
    
    private func _showAction(at index: Int) -> SKAction {
        return SKAction.sequence([
            SKAction.wait(forDuration: Double(index) * 0.1),
            SKAction.moveTo(y: 0, duration: 0.3).setEase(.easeInEaseOut)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
