//
//  TPGameController.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/30.
//  Copyright © 2019 yuki. All rights reserved.
//

import SceneKit

class TPGameController {
    private let scene:SCNScene
    private lazy var entityWorld = TSEntityWorld(delegate: self)
    
    init(scene: SCNScene) {
        self.scene = scene
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
