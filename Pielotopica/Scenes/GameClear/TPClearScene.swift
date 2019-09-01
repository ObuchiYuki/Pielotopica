//
//  TPClearScene.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/01.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

public extension GKSceneHolder {
    static let gameClear = GKSceneHolder(safeScene: TPClearScene(), backgroundScene: TPStartBackgroundScene())
    
}

class TPClearScene:GKSafeScene {
    override func sceneDidLoad() {
        
    }
}
