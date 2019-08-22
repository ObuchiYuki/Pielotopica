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
    
    // MARK: - Global -
    let header = TPHeader()
    
    // MARK: - Main Menu -
    let mainmenu = TPMainMenu()
    
    // MARK: - Build -
    let itemBar = TPBuildItemBar(inventory: TSPlayer.him.itemBarInventory)
    
    // =============================================================== //
    // MARK: - Private Properties -
    
    // =============================================================== //
    // MARK: - Methods -
    override func sceneDidLoad() {
        super.sceneDidLoad()
        
        mainmenu.buildItem.addTarget(self, action: #selector(buildItemTap(_:)), for: .touchUpInside)
        
        self.rootNode.addChild(mainmenu)
        self.rootNode.addChild(header)
        self.rootNode.addChild(itemBar)
        
        header.helthSlider.value = 50
        header.oilSlider.value = 60
        
        itemBar.position = [0, -500]
        itemBar.isHidden = true
    }
    
    // =============================================================== //
    // MARK: - Constructor -
    
    // =============================================================== //
    // MARK: - Private Methods -
    @objc private func buildItemTap(_ button:GKButtonNode) {
        mainmenu.hide()
        
        itemBar.isHidden = false
        itemBar.run(.moveTo(y: -300, duration: 0.3))
    }
}

