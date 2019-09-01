//
//  TPClearScene.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/01.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

public extension GKSceneHolder {
    static let gameClear = GKSceneHolder(safeScene: TPClearScene(), backgroundScene: TPStartBackgroundScene())
    
}

class TPClearScene:GKSafeScene {
    private let titleLabel = SKLabelNode(fontNamed: TPCommon.FontName.topica)
    
    private let modal = TPClearModal()
    
    override func sceneDidLoad() {
        TPSandBoxRootSceneModel.shared
        titleLabel.fontSize = 50
        titleLabel.fontColor = TPCommon.Color.text
        titleLabel.position = [0, 230]
        titleLabel.run(.typewriter("Stage Clear !!", withDuration: 0.5))
        
        modal.exitButton.addTarget(self, action: #selector(exitButtonTap), for: .touchUpInside)
        
        self.rootNode.addChild(titleLabel)
        self.rootNode.addChild(modal)
    }
    
    @objc func exitButtonTap(_ sender:Any) {
        self.gkViewContoller.presentScene(with: .sandboxScene)
    }
}
