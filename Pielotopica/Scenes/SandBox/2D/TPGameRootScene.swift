//
//  TPGameRootScene.swift
//  Pielotopica
//
//  Created by yuki on 2019/10/13.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

public extension GKSceneHolder {

    static let gameScene = GKSceneHolder(safeScene: TPGameRootScene(), background3DScene: TPSandboxSceneController())
    
}

// ======================================================== //
// MARK: - TPGameRootScene -

/**
 3D表示行うゲームシーン全般はこのシーンの上に表示されます。
 
 -- 使用方法 --
  
 1. `TPGameScene`に準拠したクラスを作ります。(`TPGameScene`は`GKSafeScene`と同様に扱えます。)
 2.
 - `show<T: TPGameScene>(from oldScene: T,_ completion: @escaping ()->Void?)`
 - `hide<T: TPGameScene>(to newScene: T, _ completion: @escaping ()->Void?)`
 メソッドを実装してください。
 　
 3. 次の`Scene`に `TPGameRootSceneModel.shared.present(to: scene)`で移ってください。
 4.
 */
class TPGameRootScene: GKSafeScene {

    // ======================================================== //
    // MARK: - Properties -
    
    private let sceneModel = TPGameRootSceneModel.shared
    
    private var currentScene:TPGameScene!
    private var _presentLock = false
    
    // ======================================================== //
    // MARK: - Methods -
    override func sceneDidLoad() {
        super.sceneDidLoad()
        
        if TPCommon.debug { self.rootNode.color = UIColor.black.withAlphaComponent(0.2) }
        
        self.sceneModel.initiarize(with: self)
    }
    
    override func sceneDidAppear() {
        // 初期表示
        self.sceneModel.present(to: TPGMainScene())
    }
    
    // MARK: - Privates -
    /// Sceneを次のSceneに受け渡します。
    private func _showNewScene(with newScene:TPGameScene, from oldScene: TPGameScene?) {
        newScene.rootNode.removeFromParent()
        dump(type(of: newScene))
        self.rootNode.addChild(newScene.rootNode)
        
        newScene.show(from: oldScene)
    }
}

// ======================================================== //
// MARK: - Binder -
extension TPGameRootScene: TPGameRootSceneModelBinder {
    func __present(to scene: TPGameScene) {
        // lock 機構
        guard !_presentLock else { return }; _presentLock = true
        
        // show
        
        _showNewScene(with: scene, from: self.currentScene)
        
        // hide
        if let oldScene = currentScene {
            oldScene.hide(to: scene) { [oldScene] in
                self._presentLock = false
                oldScene.rootNode.removeFromParent()
            }
        } else {
            self._presentLock = false
        }

        currentScene = scene
    }
}
