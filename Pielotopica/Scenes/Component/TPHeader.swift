//
//  TPHeader.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/21.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

class TPHeader: SKSpriteNode {
    init(){
        super.init(texture: .init(imageNamed: "TP_hd_background"), color: .clear, size: [354, 119])
        
        self.anchorPoint = .zero
        self.position = [-GKSafeScene.sceneSize.width / 2 + 10, GKSafeScene.sceneSize.height / 2 - 130]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
