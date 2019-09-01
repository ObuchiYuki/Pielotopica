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
    
    private let itemBar = TPBuildItemBar(inventory: TSItemBarInventory.itembarShared)
    private let buildSideMenu = TPBuildSideMenu()
    
    private let timeBar = TSBattleTimer()
    
    override func sceneDidLoad() {
        GKSoundPlayer.shared.playMusic(.battleMusic)
        
        itemBar.backButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
        
        itemBar.placeButton.addTarget(self, action: #selector(placeButtonDidTap), for: .touchUpInside)
        itemBar.moveButton.addTarget(self, action: #selector(moveButtonDidTap), for: .touchUpInside)
        itemBar.destoryButton.addTarget(self, action: #selector(destoryButtonDidTap), for: .touchUpInside)
        
        itemBar.moreButton.addTarget(self, action: #selector(moreButtonDidTap), for: .touchUpInside)
        
        buildSideMenu.rotateItem.addTarget(self, action: #selector(rotateDidTap), for: .touchUpInside)
        
        self.rootNode.addChild(itemBar)
        self.rootNode.addChild(buildSideMenu)
        self.rootNode.addChild(timeBar)
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

extension TPSBattleScene: TPSBattleSceneModelBinder {
    func __setTime(_ time: Int, max: Int) {
        self.timeBar.setTime((time.d / max.d)) 
    }
    func __showAlert(with alert:TPAlert) {
        self.rootNode.addChild(alert)
        alert.show()
    }
    
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

extension TPSBattleScene: TPSandBoxScene {
    var __sceneMode: TPSandBoxRootSceneModel.Mode { .battle }
    
    
    var __sceneModel: TPSandBoxSceneModel{
        sceneModel
    }
    
    func show(from oldScene: TPSandBoxRootSceneModel.Mode?) {
        timeBar.show()
        itemBar.show(animated: true)
        itemBar.showDrops(animated: true)
    }
    func hide(to newScene: TPSandBoxRootSceneModel.Mode, _ completion: @escaping () -> Void) {
        timeBar.hide()
        itemBar.hideDrops(animated: true)
        itemBar.hide(animated: true) {
            completion()
        }
    }
    
}
