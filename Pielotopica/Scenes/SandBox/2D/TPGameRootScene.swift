//
//  TPGameRootScene.swift
//  Pielotopica
//
//  Created by yuki on 2019/10/13.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

public extension GKSceneHolder {
    static let gameScene = GKSceneHolder(safeScene: TPGameRootScene(), background3DScene: TPSandboxSceneController())
    
}


class TPGameRootScene: GKSafeScene {
    let menuItem = TPFlatButton(
        defaultTexture: "TP_menu_flatbutton",
        selectedTexture: "TP_menu_flatbutton_pressed",
        label: "メニュー"
    )
    
    override func sceneDidLoad() {
        
        self.rootNode.color = UIColor.black.withAlphaComponent(0.2)
        
        
        self.rootNode.addChild(menuItem)
    }
}
