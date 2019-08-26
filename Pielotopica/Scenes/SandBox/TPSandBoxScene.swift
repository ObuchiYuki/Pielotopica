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
    static let sandboxScene = GKSceneHolder(safeScene: TPSandBoxScene(), background3DScene: TPSandboxSceneController())
    
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
    let buildSideMenu = TPBuildSideMenu()
    
    // =============================================================== //
    // MARK: - Private Properties -
    
    private lazy var sceneModel = TPSandBoxSceneUIModel(self)
    
    // =============================================================== //
    // MARK: - Methods -
    override func sceneDidLoad() {
        super.sceneDidLoad()
            
        sceneModel.mode.accept(.mainmenu)
        
        rootNode.color = UIColor.black.withAlphaComponent(0.5)
        
        mainmenu.menuItem.addTarget(self, action: #selector(mainMenuItemDidTap), for: .touchUpInside)
        mainmenu.buildItem.addTarget(self, action: #selector(mainBuildItemDidTap), for: .touchUpInside)
        mainmenu.captureItem.addTarget(self, action: #selector(mainCaptureItemDidTap), for: .touchUpInside)
        mainmenu.shopItem.addTarget(self, action: #selector(mainShopItemDidTap), for: .touchUpInside)
        
        itemBar.backButton.addTarget(self, action: #selector(buildBackButtonDidTap), for: .touchUpInside)
        itemBar.placeButton.addTarget(self, action: #selector(buildPlaceButtonDidTap), for: .touchUpInside)
        itemBar.moveButton.addTarget(self, action: #selector(buildMoveButtonDidTap), for: .touchUpInside)
        itemBar.destoryButton.addTarget(self, action: #selector(buildDestoryButtonDidTap), for: .touchUpInside)
        
        buildSideMenu.rotateItem.addTarget(self, action: #selector(buildSideMenuRotateDidTap), for: .touchUpInside)
        
        self.rootNode.addChild(buildSideMenu)
        self.rootNode.addChild(mainmenu)
        self.rootNode.addChild(header)
        self.rootNode.addChild(itemBar)
        
    }
    
    // =============================================================== //
    // MARK: - Constructor -
    
    // =============================================================== //
    // MARK: - Private Methods -
    
    // MARK: - Main Menu Button Handlers -
    @objc private func mainMenuItemDidTap(_ button:GKButtonNode) {
        sceneModel.onMainMenuMenuItemTap()
    }
    @objc private func mainBuildItemDidTap(_ button:GKButtonNode) {
        sceneModel.onMainMenuBuildItemTap()
    }
    @objc private func mainCaptureItemDidTap(_ button:GKButtonNode) {
        sceneModel.onMainMenuCaptureItemTap()
    }
    @objc private func mainShopItemDidTap(_ button:GKButtonNode) {
        sceneModel.onMainMenuShopItemTap()
    }
    
    // MARK: - Build Scene Button Handlers -
    @objc private func buildBackButtonDidTap(_ button:GKButtonNode) {
        sceneModel.onBuildBackButtonTap()
    }
    @objc private func buildPlaceButtonDidTap(_ button:GKButtonNode) {
        sceneModel.onBuildPlaceButtonTap()
    }
    @objc private func buildMoveButtonDidTap(_ button:GKButtonNode) {
        sceneModel.onBuildMoveButtonTap()
    }
    @objc private func buildDestoryButtonDidTap(_ button:GKButtonNode) {
        sceneModel.onBuildDestroyButtonTap()
    }
    
    @objc private func buildSideMenuRotateDidTap(_ button:GKButtonNode){
        sceneModel.onSideMenuRotateButtonTap()
    }
}

extension TPSandBoxScene: TPSandBoxSceneUIModelBinder {
    var __viewController: UIViewController {
        return super.gkViewContoller
    }
    
    func __showMainMenu() {
        mainmenu.show()
    }
    func __hideMainMenu() {
        mainmenu.hide()
    }
    
    func __showItemBar() {
        itemBar.show()
    }
    func __hideItemBar() {
        itemBar.hide()
    }
    
    func __setItemBarSelectionState(to state: TPItemBarSelectionState) {
        itemBar.placeButton.selectionState = false
        itemBar.moveButton.selectionState = false
        itemBar.destoryButton.selectionState = false
        
        switch state {
        case .place:  itemBar.placeButton.selectionState = true
        case .move:   itemBar.moveButton.selectionState = true
        case .destory:itemBar.destoryButton.selectionState = true
            
        default: break
        }
    }
    
    func __setBuildSideMenuMode(to mode:TPItemBarSelectionState) {
        buildSideMenu.show(as: mode)
    }
}
