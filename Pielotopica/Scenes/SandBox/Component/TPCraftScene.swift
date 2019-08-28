//
//  TPCraftOverLay.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/27.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

class TPCraftScene: SKSpriteNode {
    private let craftMenu = TPCraftMenu()
    private let moreItem = TPCraftMoreItems()
    
    func show() {
        self.isHidden = false
    }
    func hide() {
        self.isHidden = true
    }
    
    init() {
        super.init(texture: nil, color: .clear, size: GKSafeScene.sceneSize)
        
        self.isHidden = true
        
        craftMenu.position = [0, 140]
        moreItem.position = [0, -80]
        
        self.addChild(craftMenu)
        self.addChild(moreItem)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


