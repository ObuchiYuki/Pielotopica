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
    static let storyScene = GKSceneHolder(safeScene: TPStoryScene(), background3DScene: TPSandboxSceneController())
    
}

class TPStoryScene: GKSafeScene {
    // =============================================================== //
    // MARK: - Properties -
    private let tabitemSetting = _TPStartSceneRing()
    // =============================================================== //
    // MARK: - Private Properties -
    
    // =============================================================== //
    // MARK: - Methods -
    override func sceneDidLoad() {
        tabitemSetting.position = rootNode.position
        tabitemSetting.addTarget(self, action: #selector(tap(_:)), for: .touchUpInside)
        
        rootNode.addChild(tabitemSetting)
    }
    // =============================================================== //
    // MARK: - Constructor -
    
    // =============================================================== //
    // MARK: - Private Methods -
    
    @objc func tap(_ s:Any) {
        print("tappes")
    }
}

