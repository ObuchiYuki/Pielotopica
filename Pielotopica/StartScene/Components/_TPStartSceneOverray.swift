//
//  _TPStartSceneOverray.swift
//  TPStartScene
//
//  Created by yuki on 2019/07/07.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

// =============================================================== //
// MARK: - _TPStartSceneOverray -

/**
 */
class _TPStartSceneOverray:SKSpriteNode {
    // =============================================================== //
    // MARK: - Constructor -
    init() {
        super.init(texture: .init(imageNamed: "TP_overray"), color: .clear, size: GKSafeScene.sceneSize)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // =============================================================== //
    // MARK: - Private Methods -
}
