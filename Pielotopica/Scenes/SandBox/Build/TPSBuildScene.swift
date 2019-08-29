//
//  TPSBuildScene.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/28.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

class TPSBuildScene: GKSafeScene {
    
    // nodes
    private let itemBar = TPBuildItemBar(inventory: TSItemBarInventory.itembarShared)
    private let buildSideMenu = TPBuildSideMenu()
    
    lazy var sceneModel = TPSBuildSceneModel(self)
    
    override func sceneDidLoad() {
        itemBar.backButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
        
        itemBar.placeButton.addTarget(self, action: #selector(placeButtonDidTap), for: .touchUpInside)
        itemBar.moveButton.addTarget(self, action: #selector(moveButtonDidTap), for: .touchUpInside)
        itemBar.destoryButton.addTarget(self, action: #selector(destoryButtonDidTap), for: .touchUpInside)
        
        itemBar.moreButton.addTarget(self, action: #selector(moreButtonDidTap), for: .touchUpInside)
        
        buildSideMenu.rotateItem.addTarget(self, action: #selector(rotateDidTap), for: .touchUpInside)
        
        self.rootNode.addChild(itemBar)
        self.rootNode.addChild(buildSideMenu)
    }
    
    @objc private func backButtonDidTap(_ button:GKButtonNode) {
        sceneModel.onBackButtonTap()
    }
    @objc private func placeButtonDidTap(_ button:GKButtonNode) {
        sceneModel.onPlaceButtonTap()
    }
    @objc private func moveButtonDidTap(_ button:GKButtonNode) {
        sceneModel.onMoveButtonTap()
    }
    @objc private func destoryButtonDidTap(_ button:GKButtonNode) {
        sceneModel.onDestoryButtonTap()
    }
    
    @objc private func moreButtonDidTap(_ button:GKButtonNode) {
        sceneModel.onMoreButtonTap()
    }
    
    @objc private func rotateDidTap(_ button:GKButtonNode){
        sceneModel.onRotateButtonTap()
    }
}

extension TPSBuildScene: TPSandBoxScene {
    var __sceneModel: TPSandBoxSceneModel { sceneModel }
    
    func show(from oldScene: TPSandBoxRootSceneModel.Mode) {
        if oldScene == .craft {
            itemBar.show(animated: false)
            itemBar.showDrops()
        }else{
            itemBar.show()
            itemBar.showDrops()
        }
    }
    func hide(to newScene: TPSandBoxRootSceneModel.Mode, _ completion: @escaping () -> Void) {
        if newScene == .craft {
            itemBar.hide(animated: false)
            completion()
        }else{
            itemBar.hide()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
                completion()
            })
        }
    }
}

extension TPSBuildScene: TPSBuildSceneModelBinder {
    func __setItemBarSelectionState(to mode:TPSBuildSceneModel.Mode) {
        self.itemBar.allDropButtons.forEach{$0.selectionState = false}
        
        switch mode {
        case .place:
            self.itemBar.placeButton.selectionState = true
        case .move:
            self.itemBar.moveButton.selectionState = true
        case .destory:
            self.itemBar.destoryButton.selectionState = true
        }
    }
    func __setBuildSideMenuMode(to mode:TPSBuildSceneModel.Mode) {
        buildSideMenu.show(as: mode)
    }
}