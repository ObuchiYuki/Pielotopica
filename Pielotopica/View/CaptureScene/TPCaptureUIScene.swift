//
//  TPCaptureUIScene.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/25.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

class TPCaptureUIScene: GKSafeScene {
    let header = TPHeader()
    
    
    override func sceneDidLoad() {
        self.rootNode.addChild(header)
        
    }
}
