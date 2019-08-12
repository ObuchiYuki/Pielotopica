//
//  _TPStartSceneEdgeBar.swift
//  TPStartScene
//
//  Created by yuki on 2019/07/07.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

// =============================================================== //
// MARK: - _TPStartSceneEdgeBar -

/**
 */
class _TPStartSceneEdgeBar:SKSpriteNode {
    // =============================================================== //
    // MARK: - Properties -
    private let nodeWidth = GKSafeScene.sceneSize.width - 20
    
    private let leftDotNode = SKSpriteNode(color: TPCommon.Color.icon, size: [7, 7])
    private let rightDotNode = SKSpriteNode(color: TPCommon.Color.icon, size: [7, 7])
    
    private let lineNode = SKSpriteNode(color: TPCommon.Color.icon, size: [2, 2])
    // -> 330
    // =============================================================== //
    // MARK: - Private Properties -
    
    // =============================================================== //
    // MARK: - Methods -
    
    // =============================================================== //
    // MARK: - Constructor -
    init() {
        super.init(texture: nil, color: .clear, size: [GKSafeScene.sceneSize.width, 7])
        
        self.setupNodes()
        self.startAnimating()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // =============================================================== //
    // MARK: - Private Methods -
    private func startAnimating() {
        lineNode.run(
            SKAction.scaleX(to: (nodeWidth - 50) / 2, duration: 0.7)
        )
    }
    private func setupNodes() {
        leftDotNode.position = [-(nodeWidth / 2) + 5, 3.5]
        rightDotNode.position = [(nodeWidth / 2) - 5, 3.5]
        lineNode.position = [0, 3.5]
        
        addChild(leftDotNode)
        addChild(rightDotNode)
        addChild(lineNode)
    }
}
