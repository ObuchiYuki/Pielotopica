//
//  TPSCraftScene.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/28.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit
import RxSwift
import RxCocoa


class TPSCraftScene: GKSafeScene {
    // ===================================================================== //
    // MARK: - Properties -
    
    lazy var sceneModel = TPSCraftSceneModel(self)
    private let bag = DisposeBag()
    
    private lazy var overrayNode = _createOverlay()
    private let itemBar = TPBuildItemBar(inventory: TSItemBarInventory.itembarShared)
    private let craftMenu = TPCraftMenu()
    private let moreItem = TPCraftMoreItems()
    
    private var backgroundScene:SKScene { gkViewContoller.skView.scene! }
    
    // ===================================================================== //
    // MARK: - Handler -
    
    @objc private func backAction(_ button: Any) {
        sceneModel.onBackAction()
    }
    @objc private func craftButtonDidTap(_ button:GKButtonNode) {
        sceneModel.onCraftTap()
    }
    
    // ===================================================================== //
    // MARK: - Methdos -
    
    override func sceneDidLoad() {
        
        self.moreItem.selectedItemIndex.subscribe {[unowned self] event in
            event.element.map{self.sceneModel.onIndexChange(to: $0)}
            
        }.disposed(by: bag)
        
        self.craftMenu.craftButton.addTarget(self, action: #selector(craftButtonDidTap), for: .touchUpInside)
                
        self.itemBar.moreButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        self.itemBar.backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        self.itemBar.show(animated: false)
        
        self.rootNode.addChild(itemBar)
        self.rootNode.addChild(moreItem)
        self.rootNode.addChild(craftMenu)
    }
    
    // ===================================================================== //
    // MARK: - Private Methods -
        
    private func _createOverlay() -> SKSpriteNode {
        let node = SKSpriteNode(color: UIColor.init(hex: 0, alpha: 0.5), size: backgroundScene.size)
        node.position = backgroundScene.size.point / 2
        return node
    }
}

extension TPSCraftScene: TPSCraftSceneModelBinder {
    var __itemBarSelectedIndex:Int {
        return TSItemBarInventory.itembarShared.selectedItemIndex.value
    }
    
    func __checkCraftableState() {
        self.craftMenu.checkState()
    }
    
    func __changeCraftMenu(with item:TSItem) {
        self.craftMenu.setItem(item)
    }
    func __placeItemBar(from inventoryIndex: Int, at index: Int) {
        TSItemBarInventory.itembarShared.placeItemStack(from: inventoryIndex, at: index)
    }
}


extension TPSCraftScene: TPSandBoxScene {
    var __sceneMode: TPSandBoxRootSceneModel.Mode { .craft }
    
    var __sceneModel: TPSandBoxSceneModel { sceneModel }
    
    func show(from oldScene: TPSandBoxRootSceneModel.Mode?) {
        overrayNode.removeFromParent()
        self.backgroundScene.addChild(overrayNode)
    }
    func hide(to newScene: TPSandBoxRootSceneModel.Mode, _ completion: @escaping () -> Void) {
        overrayNode.removeFromParent()
        completion()
    }
}

