//
//  TPGMainScene.swift
//  Pielotopica
//
//  Created by yuki on 2019/10/14.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

// ================================================================ //
// MARK: - TPGMainScene -
class TPGMainScene: GKSafeScene {
    // ================================================================ //
    // MARK: - Nodes -
    
    private let _controller = TPControllerNode()
    
    // ================================================================ //
    // MARK: - Methods -
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        
        _controller.position = [100, 100]
        self.rootNode.name = "over"
        self.rootNode.color = .green
        self.rootNode.addChild(_controller)
    }
    
}

extension TPGMainScene: TPGameScene {
    func show(from oldScene: TPGameScene?) {
        
    }
    
    func hide(to newScene: TPGameScene, _ completion: @escaping () -> Void) {
        completion()
    }
}
