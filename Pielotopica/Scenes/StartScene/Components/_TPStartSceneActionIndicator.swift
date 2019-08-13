//
//  _TPStartSceneActionIndicator.swift
//  TPStartScene
//
//  Created by yuki on 2019/07/07.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

// =============================================================== //
// MARK: - _TPActionIndicator -

/**
 */
class _TPStartSceneActionIndicator:SKSpriteNode {
    // =============================================================== //
    // MARK: - Private Properties -
    private let topBar = SKSpriteNode(color: TPCommon.Color.icon, size: [160, 2])
    private let actionLabel = SKLabelNode(fontNamed: TPCommon.FontName.topica)
    
    // =============================================================== //
    // MARK: - Constructor -
    init(action:String) {
        super.init(texture: nil, color: .clear, size: [160, 40])
        
        topBar.position.y = 19
        actionLabel.position.y = -6
        actionLabel.fontColor = TPCommon.Color.text
        actionLabel.fontSize = 20
        
        self.addChild(actionLabel)
        self.addChild(topBar)
        
        actionLabel.run(.typewriter(action, withDuration: 0.6))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // =============================================================== //
    // MARK: - Private Methods -
}
