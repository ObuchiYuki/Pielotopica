//
//  TPBuildItemBar.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/22.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

class TPBuildItemBar: SKSpriteNode {
    let inventory:TSItemBarInventory
    
    init(inventory:TSItemBarInventory) {
        self.inventory = inventory
        
        super.init(texture: .init(imageNamed: "TP_build_itembar_frame"), color: .clear, size: [312, 80])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
