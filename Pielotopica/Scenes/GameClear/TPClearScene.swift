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
        titleLabel.fontSize = 50
        titleLabel.fontColor = TPCommon.Color.text
        titleLabel.position = [0, 230]
        titleLabel.run(.typewriter("Stage Clear !!", withDuration: 0.5))
        
        self.rootNode.addChild(titleLabel)
        self.rootNode.addChild(modal)
    }
}
