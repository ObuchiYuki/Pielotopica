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
        for anchor in level.getAllAnchors().filter({$0.y == 1}) {
            let sprite = TSSprite(sprite: SKSpriteNode.init(color: .red, size: [100, 100]))
            sprite.show(at: (anchor + [0, 1, 0]).scnVector3, in: scene)
        }
        
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
