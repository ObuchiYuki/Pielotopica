//
//  TPGameOverScene.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/01.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

public extension GKSceneHolder {
    static let gameOver = GKSceneHolder(
        safeScene: TPGameOverScene(),
        backgroundScene: TPGameOverBackgronudScene()
    )
}

class TPGameOverScene: GKSafeScene {
    private let titleLabel = SKLabelNode(fontNamed: TPCommon.FontName.topica)
    private let modal = TPGameOverModal()
    
    override func sceneDidLoad() {
        
        titleLabel.fontSize = 50
        titleLabel.fontColor = TPCommon.Color.card
        titleLabel.position = [0, 230]
        titleLabel.run(.typewriter("Game Over...", withDuration: 0.5))
        
        modal.exitButton.addTarget(self, action: #selector(exitButtonTap), for: .touchUpInside)
        
        self.rootNode.addChild(titleLabel)
        self.rootNode.addChild(modal)
        
        self.loadData()
    }
    
    private func loadData() {
        guard let endData = TPGameController.lastGameEndData else { return showDebugMessage("どうやってここにきたの...？")}
        
        modal.load(endData)
        
        let award = endData.award
        
        TSMaterialData.shared.addIron(-award.iron)
        TSMaterialData.shared.addWood(-award.wood)
        TSMaterialData.shared.addCircit(-award.circit)
        TSFuelData.shared.addFuel(-award.fuel)
        
    }
    
    @objc func exitButtonTap(_ sender:Any) {
        self.gkViewContoller.presentScene(with: .sandboxScene)
    }
}
