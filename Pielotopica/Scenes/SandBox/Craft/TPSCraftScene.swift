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
    lazy var overrayNode:SKSpriteNode = _createOverlay()
    
    lazy var sceneModel = TPSCraftSceneModel(self)
    private let bag = DisposeBag()
    
    private let craftMenu = TPCraftMenu()
    private let moreItem = TPCraftMoreItems()
    
    private var backgroundScene:SKScene { gkViewContoller.scnView.overlaySKScene! }
    
    // ===================================================================== //
    // MARK: - Handler -
    @objc private func overlayTouched(_ button:GKButtonNode) {
        moreItem.selectedItemIndex.subscribe {[weak self] event in
            fatalError()
            //event.element.map(self!.sceneMode(to: ))
            
        }.disposed(by: bag)
        
        sceneModel.onOverlayTap()
    }
    
    // ===================================================================== //
    // MARK: - Private Methods -
    
    override func sceneDidLoad() {
                
        self.rootNode.addChild(moreItem)
        self.rootNode.addChild(craftMenu)
    }
    
    private func _createOverlay() -> SKSpriteNode {
        let node = GKButtonNode(size: backgroundScene.size)
        node.addTarget(self, action: #selector(overlayTouched), for: .touchUpInside)
        node.color = UIColor.init(hex: 0, alpha: 0.95)
        node.zPosition = -1
        node.position = backgroundScene.size.point / 2
        
        return node
    }
}

extension TPSCraftScene: TPSandBoxScene {
    var __sceneModel: TPSandBoxSceneModel { sceneModel }
    
    func show(from oldScene: TPSandBoxRootSceneModel.Mode) {
        backgroundScene.backgroundColor = .red
        self.backgroundScene.addChild(overrayNode)
    }
    func hide(to newScene: TPSandBoxRootSceneModel.Mode, _ completion: @escaping () -> Void) {
        completion()
    }
}

extension TPSCraftScene: TPSCraftSceneModelBinder {
    
}
