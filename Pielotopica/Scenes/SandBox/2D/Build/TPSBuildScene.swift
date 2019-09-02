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
    private let noticeLabel = GKShadowLabelNode(fontNamed: TPCommon.FontName.hiraBold)
    
    private lazy var sceneModel = TPSBuildSceneModel(self)
    
    private var __hideTag = UUID()
    
    override func sceneDidLoad() {
        
        RMBindCenter.default.addObserver(forName: .TPBuildNotification) {[weak self] in
            self?.showNotice($0)
        }
        
        noticeLabel.position = [0, -160]
        noticeLabel.fontColor = .white
        noticeLabel.fontSize = 15
        noticeLabel.horizontalAlignmentMode = .center
        noticeLabel.isHidden = true
        
        noticeLabel.barnShadow()
        
        self.rootNode.addChild(noticeLabel)
        
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
    
    private func showNotice(_ notice: TPBuildNotice) {
        noticeLabel.isHidden = false
        noticeLabel.text = notice.text
        noticeLabel.fontColor = notice.color
        
        let id = UUID()
        __hideTag = id

        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            if id == self.__hideTag {
                self.noticeLabel.isHidden = true
            }
        })
    }
}

extension TPSBuildScene: TPSandBoxScene {
    var __sceneMode: TPSandBoxRootSceneModel.Mode { .build }
    
    var __sceneModel: TPSandBoxSceneModel { sceneModel }
    
    func show(from oldScene: TPSandBoxRootSceneModel.Mode?) {
        if oldScene == .craft {
            itemBar.show(animated: false)
            itemBar.showDrops(animated: true)
        }else{
            itemBar.show(animated: true)
            itemBar.showDrops(animated: true)
        }
    }
    func hide(to newScene: TPSandBoxRootSceneModel.Mode, _ completion: @escaping () -> Void) {
        buildSideMenu.hide()
        if newScene == .craft {
            itemBar.hide(animated: false)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                completion()
            })
        }else{
            itemBar.hide(animated: true)
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
