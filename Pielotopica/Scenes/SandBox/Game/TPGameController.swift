//
//  TPGameController.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/30.
//  Copyright © 2019 yuki. All rights reserved.
//

import SceneKit

class TPGameController {
    let scene:SCNScene
    
    let entityWorld:TSEntityWorld
    
    init(scene: SCNScene) {
        self.scene = scene
        self.entityWorld = TSEntityWorld(delegate: self)
    }
    
    func start() {
        self.entityWorld.start()
    }
}

extension TPGameController: TSEntityWorldDelegate {
    func addNode(_ node: SCNNode) {
        self.scene.rootNode.addChildNode(node)
    }
}
