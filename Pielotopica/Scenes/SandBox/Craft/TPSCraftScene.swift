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
    
    private var backgroundScene:SKScene { gkViewContoller.scnView.overlaySKScene! }
    
    // ===================================================================== //
    // MARK: - Handler -
    
    @objc private func backAction(_ button: Any) {
        sceneModel.onBackAction()
    }
    
    // ===================================================================== //
    // MARK: - Private Methods -
    
    override func sceneDidLoad() {
                
        self.itemBar.moreButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        self.itemBar.backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        self.itemBar.show(animated: false)
        
        self.rootNode.addChild(itemBar)
        self.rootNode.addChild(moreItem)
        self.rootNode.addChild(craftMenu)
    }
    
    private func _createOverlay() -> SKSpriteNode {
        let node = GKButtonNode(size: backgroundScene.size)
        node.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        node.color = UIColor.init(hex: 0, alpha: 0.95)
        node.zPosition = -1
        node.position = backgroundScene.size.point / 2
        
        return node
    }
}

extension TPSCraftScene: TPSandBoxScene {
    var __sceneModel: TPSandBoxSceneModel { sceneModel }
    
    func show(from oldScene: TPSandBoxRootSceneModel.Mode) {
        self.backgroundScene.addChild(overrayNode)
    }
    func hide(to newScene: TPSandBoxRootSceneModel.Mode, _ completion: @escaping () -> Void) {
        overrayNode.removeFromParent()
        completion()
    }
}

extension TPSCraftScene: TPSCraftSceneModelBinder {
    
}
