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
        
        menuItem.position = .zero
        buildItem.position = [CGFloat((76+8) * 1), 0]
        captureItem.position = [CGFloat((76+8) * 2), 0]
        shopItem.position = [CGFloat((76+8) * 3), 0]
        
        
        addChild(menuItem)
        addChild(buildItem)
        addChild(captureItem)
        addChild(shopItem)
        
        self.position = [
            -GKSafeScene.sceneSize.width / 2 + 23,
            -GKSafeScene.sceneSize.height / 2 + 76 + 20
        ]
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
