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
    static let storyScene = GKSceneHolder(safeScene: TPSandBoxScene(), background3DScene: TPSandboxSceneController())
    
}

class TPSandBoxScene: GKSafeScene {
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
    
    private var sceneModel:TPSandboxSceneModel { TPSandboxSceneModel.initirized! }
    
    // =============================================================== //
    // MARK: - Methods -
    override func sceneDidLoad() {
        super.sceneDidLoad()
        
        rootNode.color = UIColor.black.withAlphaComponent(0.5)
        mainmenu.buildItem.addTarget(self, action: #selector(buildItemTap(_:)), for: .touchUpInside)
        mainmenu.captureItem.addTarget(self, action: #selector(buildCaptureTap(_:)), for: .touchUpInside)
        itemBar.backButton.addTarget(self, action: #selector(buildBackTap(_:)), for: .touchUpInside)
        
        self.rootNode.addChild(mainmenu)
        self.rootNode.addChild(header)
        self.rootNode.addChild(itemBar)
        
        header.helthSlider.value = 50
        header.oilSlider.value = 60
    }
    
    // =============================================================== //
    // MARK: - Constructor -
    
    // =============================================================== //
    // MARK: - Private Methods -
    
    @objc private func buildCaptureTap(_ button:GKButtonNode) {
        (gkViewContoller.presentingViewController as! RouterViewController).route = .capture
        
        gkViewContoller.dismiss(animated: false, completion: {})
    }
    
    @objc private func buildItemTap(_ button:GKButtonNode) {
        mainmenu.hide()
        itemBar.show()
    }
    
    @objc private func buildBackTap(_ button:GKButtonNode) {
        mainmenu.show()
        itemBar.hide()
    }
}

