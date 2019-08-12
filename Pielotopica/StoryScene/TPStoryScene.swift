//
//  TPStoryScene.swift
//  TPStartScene
//
//  Created by yuki on 2019/07/08.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit
import GameplayKit

// =============================================================== //
// MARK: - TPStoryScene -

public extension GKSceneHolder {
    static let storyScene = GKSceneHolder(safeScene: TPStoryScene(), background3DScene: TPStoryBackgroundSceneController())
    
}

class TPStoryScene: GKSafeScene {
    // =============================================================== //
    // MARK: - Properties -
    
    // =============================================================== //
    // MARK: - Private Properties -
    
    // =============================================================== //
    // MARK: - Methods -
    override func sceneDidLoad() {
        self.rootNode.color = .clear
        
    }
    // =============================================================== //
    // MARK: - Constructor -
    
    // =============================================================== //
    // MARK: - Private Methods -
}


class TPStoryBackgroundSceneController: GK3DSceneController {
    var node:SCNNode = {
        let node = SCNNode()
        let box = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
        
        node.geometry = box
        
        return node
    }()
    
    override func sceneDidLoad() {

        self.rootNode.addChildNode(node)
    }
}

