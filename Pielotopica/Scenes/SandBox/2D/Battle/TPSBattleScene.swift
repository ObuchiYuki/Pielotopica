//
//  TPSButtleScene.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/29.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

class TPSBattleScene: GKSafeScene {
    private lazy var sceneModel = TPSBattleSceneModel(self)
    
    private let itembar = TPBuildItemBar(inventory: TSItemBarInventory.itembarShared)
    private let timeBar = TSBattleTimer()
    
    override func sceneDidLoad() {
        
        itembar.backButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
        
        self.rootNode.addChild(itembar)
        self.rootNode.addChild(timeBar)
    }
    
    @objc private func backButtonDidTap() {
        sceneModel.onBackButtonTap()
    }
}

extension TPSBattleScene: TPSBattleSceneModelBinder {
    
}

extension TPSBattleScene: TPSandBoxScene {
    var __sceneMode: TPSandBoxRootSceneModel.Mode { .battle }
    
    
    var __sceneModel: TPSandBoxSceneModel{
        sceneModel
    }
    
    func show(from oldScene: TPSandBoxRootSceneModel.Mode?) {
        itembar.show(animated: true)
        itembar.showDrops(animated: true)
    }
    func hide(to newScene: TPSandBoxRootSceneModel.Mode, _ completion: @escaping () -> Void) {
        itembar.hideDrops(animated: true)
        itembar.hide(animated: true) {
            completion()
        }
    }
    
}
