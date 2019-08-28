//
//  TPCraftMoreItems.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/27.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

class TPCraftMoreItems: SKSpriteNode {
    override var needsHandleReaction: Bool { true }
    
    init() {
        super.init(texture: .init(imageNamed: "TP_craft_moreitems_background"), color: .clear, size: [314, 198])
        
        self.zPosition = 100
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
