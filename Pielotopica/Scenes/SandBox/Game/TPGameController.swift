//
//  TPGameController.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/30.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit
import SceneKit

class TPGameController {
    
    // ===================================================================== //
    // MARK: - Properties -
    private let scene:SCNScene
    private let level = TSLevel.current!
    
    /// 敵の目的地
    private lazy var entityWorld = TSEntityWorld(delegate: self)
    
    // ===================================================================== //
    // MARK: - Methods -
    
    func start() {
        level.delegate2 = self
        TSDurablityManager.shared.connect(scene: scene)
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

extension TPGameController: TSLevelDelegate {
    func level(_ level: TSLevel, levelDidUpdateBlockAt position: TSVector3, needsAnimation animiationFlag: Bool) {
        entityWorld.onPlaceObject(at: position)
    }
    
    func level(_ level: TSLevel, levelWillDestoryBlockAt position: TSVector3) {
        entityWorld.onDestoryObject(at: position)
    }
}

extension TPGameController: TSEntityWorldDelegate {
    func addNode(_ node: SCNNode) {
        self.scene.rootNode.addChildNode(node)
    }
}
