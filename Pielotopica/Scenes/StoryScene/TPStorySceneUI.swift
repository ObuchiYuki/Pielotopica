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
    let button = GKButtonNode(size: [100, 100])
    // =============================================================== //
    // MARK: - Private Properties -
    
    // =============================================================== //
    // MARK: - Methods -
    override func sceneDidLoad() {
        button.defaultTexture = SKTexture(image: #imageLiteral(resourceName: "TP_startmenu_playbutton_background"))
        button.position = rootNode.position
        button.addTarget(self, action: #selector(tap(_:)), for: .touchUpInside)
        rootNode.addChild(button)
    }
    // =============================================================== //
    // MARK: - Constructor -
    
    // =============================================================== //
    // MARK: - Private Methods -
    
    @objc func tap(_ s:Any) {
        print("tappes")
    }
}

