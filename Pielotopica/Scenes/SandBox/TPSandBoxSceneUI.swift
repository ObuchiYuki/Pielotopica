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
// MARK: - TPSandBoxUI -

public extension GKSceneHolder {
    static let storyScene = GKSceneHolder(safeScene: TPStoryScene(), background3DScene: TPSandboxSceneController())
    
}

class TPStoryScene: GKSafeScene {
    // =============================================================== //
    // MARK: - Properties -
    let mainmenu = TPMainMenu()
    let header = TPHeader()
    
    // =============================================================== //
    // MARK: - Private Properties -
    
    // =============================================================== //
    // MARK: - Methods -
    override func sceneDidLoad() {
        super.sceneDidLoad()
        //rootNode.color = UIColor.black.withAlphaComponent(0.4)
        
        self.rootNode.addChild(mainmenu)
        self.rootNode.addChild(header)
        
        header.helthSlider.value = 50
        header.oilSlider.value = 60
    }
    
    // =============================================================== //
    // MARK: - Constructor -
    
    // =============================================================== //
    // MARK: - Private Methods -
}

