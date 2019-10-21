//
//  TPGMainScene.swift
//  Pielotopica
//
//  Created by yuki on 2019/10/14.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

// ================================================================ //
// MARK: - TPGMainScene -
class TPGMainScene: GKSafeScene {
    // ================================================================ //
    // MARK: - Nodes -
    
    private let _controller = TPControllerNode.shared
    private let _buildButton = TPFlatButton(
        defaultTexture: "TP_build_flatbutton",
        selectedTexture: "TP_build_flatbutton_pressed",
        label: "ビルド"
    )
    
    private let _menuButton = TPFlatButton(
        defaultTexture: "TP_menu_flatbutton",
        selectedTexture: "TP_menu_flatbutton_pressed",
        label: "メニュー"
    )
    
    private let _exitButton = TPBadgeButton(
        iconNamed: "TP_badgebutton_icon_exit"
    )
    
    // ================================================================ //
    // MARK: - Methods -
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        
        _controller.position =  [-260, -100]
        _menuButton.position =  [290, -130]
        _buildButton.position = [290, -60]
        _exitButton.position = [290, 130]
        
        
        self.rootNode.addChild(_exitButton)
        self.rootNode.addChild(_buildButton)
        self.rootNode.addChild(_menuButton)
        self.rootNode.addChild(_controller)
    }
    
}

extension TPGMainScene: TPGameScene {
    func show(from oldScene: TPGameScene?) {
        
    }
    
    func hide(to newScene: TPGameScene, _ completion: @escaping () -> Void) {
        completion()
    }
}

class TPGMainSceneModel {
    
}
