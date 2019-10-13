//
//  TPGameRootScene.swift
//  Pielotopica
//
//  Created by yuki on 2019/10/13.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

public extension GKSceneHolder {
    static let gameScene = GKSceneHolder(safeScene: TPGameRootScene(), background3DScene: TPSandboxSceneController())
    
}


class TPGameRootScene: GKSafeScene {
    override func sceneDidLoad() {
        
    }
}
