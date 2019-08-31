//
//  TPGameController.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/30.
//  Copyright © 2019 yuki. All rights reserved.
//

import SceneKit

class TPGameController {
    
    // ===================================================================== //
    // MARK: - Properties -
    private let scene:SCNScene
    
    /// 敵の目的地
    private lazy var entityWorld = TSEntityWorld(delegate: self)
    
    // ===================================================================== //
    // MARK: - Methods -
    
    func start() {
        self.entityWorld.start()
    }
    func end() {
        self.entityWorld.end()
    }
    // ===================================================================== //
    // MARK: - Constructor -
    init(scene: SCNScene) {
        self.scene = scene
    }
}

extension TPGameController: TSEntityWorldDelegate {
    func addNode(_ node: SCNNode) {
        self.scene.rootNode.addChildNode(node)
    }
}
