//
//  TPSButtleScene.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/29.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

class TPSButtleScene: GKSafeScene {
    private lazy var sceneModel = TPSButtleSceneModel(self)
    
    override func sceneDidLoad() {
        
    }
}

extension TPSButtleScene: TPSButtleSceneModelBinder {
    
}

extension TPSButtleScene: TPSandBoxScene {
    
    var __sceneModel: TPSandBoxSceneModel{
        sceneModel
    }
    
    func show(from oldScene: TPSandBoxRootSceneModel.Mode) {
        
    }
    func hide(to newScene: TPSandBoxRootSceneModel.Mode, _ completion: @escaping () -> Void) {
        completion()
    }
    
}
