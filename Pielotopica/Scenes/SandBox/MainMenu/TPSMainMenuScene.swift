//
//  TPSMainMenuScene.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/28.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

class TPSMainMenuScene: GKSafeScene {
    private let mainmenu = TPMainMenu()
    
    lazy var sceneModel = TPSMainMenuSceneModel(self)
    
    override func sceneDidLoad() {
        mainmenu.menuItem.addTarget(self, action: #selector(menuItemDidTap), for: .touchUpInside)
        mainmenu.buildItem.addTarget(self, action: #selector(buildItemDidTap), for: .touchUpInside)
        mainmenu.captureItem.addTarget(self, action: #selector(captureItemDidTap), for: .touchUpInside)
        mainmenu.shopItem.addTarget(self, action: #selector(shopItemDidTap), for: .touchUpInside)
        
        self.rootNode.addChild(mainmenu)
    }
    
    @objc private func menuItemDidTap(_ button:GKButtonNode) {
        sceneModel.onMenuItemTap()
    }
    @objc private func buildItemDidTap(_ button:GKButtonNode) {
        sceneModel.onBuildItemTap()
    }
    @objc private func captureItemDidTap(_ button:GKButtonNode) {
        sceneModel.onCaptureItemTap()
    }
    @objc private func shopItemDidTap(_ button:GKButtonNode) {
        sceneModel.onShopItemTap()
    }
}

// ================================================== //
extension TPSMainMenuScene: TPSandBoxScene {
    var __sceneModel: TPSandBoxSceneModel { sceneModel }
    
    
    func show() {
        mainmenu.show()
    }
    func hide(_ completion: @escaping () -> Void) {
        mainmenu.hide()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            completion()
        })
    }
}

extension TPSMainMenuScene: TPSMainMenuSceneModelBinder {
    var __gameViewController: GKGameViewController {
        return self.gkViewContoller
    }
}
