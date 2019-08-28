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
    
    private lazy var sceneModel = TPSCraftSceneModel(self)
    private let bag = DisposeBag()
    
    private var craftScene = TPCraftScene()
    private var backgroundScene:SKScene { return gkViewContoller.scnView.overlaySKScene! }
    
    // ===================================================================== //
    // MARK: - Handler -
    @objc private func overlayTouched(_ button:GKButtonNode) {
        craftScene.moreItem.selectedItemIndex.subscribe {[weak self] event in
            //event.element.map(self!.sceneMode(to: ))
            
        }.disposed(by: bag)
        
        sceneModel.onOverlayTap()
    }
    
    // ===================================================================== //
    // MARK: - Private Methods -
    
    private func _createOverlay() -> SKSpriteNode {
        let node = GKButtonNode(size: backgroundScene.size)
        node.addTarget(self, action: #selector(overlayTouched), for: .touchUpInside)
        node.color = UIColor.init(hex: 0, alpha: 0.95)
        node.zPosition = -1
        node.position = backgroundScene.size.point / 2
        node.isHidden = true
        self.backgroundScene.addChild(node)
        
        return node
    }
}

extension TPSCraftScene: TPSandBoxScene {
    func show() {
        
    }
    func hide(_ completion: @escaping () -> Void) {
        
    }
}

extension TPSCraftScene: TPSCraftSceneModelBinder {
    
}
