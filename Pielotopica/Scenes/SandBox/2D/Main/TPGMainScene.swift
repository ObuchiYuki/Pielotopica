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
    
    private let _controller = TPControllerNode.shared
    
    // ================================================================ //
    // MARK: - Methods -
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        
        _controller.position = [-260, -100]
        self.rootNode.addChild(_controller)
        
        _controller.speedLevel.subscribe{ print($0) }
        _controller.vector.subscribe{ print($0) }
    }
    
}

extension TPGMainScene: TPGameScene {
    func show(from oldScene: TPGameScene?) {
        
    }
    
    func hide(to newScene: TPGameScene, _ completion: @escaping () -> Void) {
        completion()
    }
}

class TPGMainSceneModel {
    
}
