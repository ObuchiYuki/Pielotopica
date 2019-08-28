//
//  TPStoryScene.swift
//  TPStartScene
//
//  Created by yuki on 2019/07/08.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit
import GameplayKit
import RxCocoa
import RxSwift

// =============================================================== //
// MARK: - TPSandBoxUI -

public extension GKSceneHolder {
    static let sandboxScene = GKSceneHolder(safeScene: TPSandBoxRootScene(), background3DScene: TPSandboxSceneController())
    
}

class TPSandBoxRootScene: GKSafeScene {
    // =============================================================== //
    // MARK: - Properties -
    
    // MARK: - Global -
    let header = TPHeader()
    
    // MARK: - Craft -
    
        
    let craftScene = TPCraftScene()
    
    // =============================================================== //
    // MARK: - Private Properties -
    
    private lazy var sceneModel = TPSandBoxSceneUIModel(self)
    private let bag = DisposeBag()
    
    
    
    // =============================================================== //
    // MARK: - Methods -
    override func sceneDidLoad() {

        craftScene.moreItem.selectedItemIndex.subscribe {[weak self] event in
            event.element.map(self!.sceneModel.onCraftMoreItemSelctedIndexChange(to: ))
            
        }.disposed(by: bag)
        
        self.rootNode.addChild(header)
    }
    
    override func sceneDidAppear() {
        (self.gkViewContoller as! GameViewController).showingScene = .sandbox
    }
    
    // =============================================================== //
    // MARK: - Constructor -
    
    // =============================================================== //
    // MARK: - Private Methods -
    
    // MARK: - Build Scene Button Handlers -
    

    
    
}

extension TPSandBoxRootScene: TPSandBoxSceneUIModelBinder {
    var __itemBarSelectedIndex: Int {
        return TSItemBarInventory.itembarShared.selectedItemIndex.value
    }
    
    func __showItemBarDrops() {
        itemBar.showDrops()
    }
    
    var __gameViewController: GKGameViewController {
        super.gkViewContoller
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
    
    func __hideItemBarDrops() {
        itemBar.hideDrops()
    }
    
    func __showCraftScene() {
        overrayNode.isHidden = false
        craftScene.show()
    }
    
    func __hideOverlayScene() {
        overrayNode.isHidden = true
        craftScene.hide()
    }
    
    func __changeCraftMenu(with item:TSItem) {
        craftScene.craftMenu.setItem(item)
    }
    
    func __placeItemBar(with itemStack:TSItemStack, at index:Int) {
        TSItemBarInventory.itembarShared.placeItemStack(itemStack, at: index)
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
