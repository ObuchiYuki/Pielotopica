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

/// 3D画面との橋渡し用
class TPSandBoxRootScene: GKSafeScene {
    // =============================================================== //
    // MARK: - Global -
    
    // node
    private let header = TPHeader()
    
    private let sceneModel = TPSandBoxRootSceneModel.shared
    
    var currentScene:TPSandBoxScene!
    
    
    // =============================================================== //
    // MARK: - Methods -
    private var _presentlock = false
    
    @discardableResult
    func present(to scene: TPSandBoxScene, as mode: TPSandBoxRootSceneModel.Mode) -> Bool {
        // lock 機構
        guard !_presentlock else { return false }
        _presentlock = true
        
        // 初期化
        scene.gkViewContoller = self.gkViewContoller
        sceneModel.onSceneChanged(to: scene)
        scene.show(from: sceneModel.mode.value)
        self.rootNode.addChild(scene.rootNode)
        
        // hide
        if let currentScene = currentScene {
            currentScene.hide(to: mode) { [currentScene] in
                self._presentlock = false
                currentScene.rootNode.removeFromParent()
            }
        } else {
            self._presentlock = false
        }

        currentScene = scene
        
        return true
    }
    
    override func sceneDidLoad() {

        self.sceneModel.binder = self
        self.rootNode.addChild(header)
        
        _ = self.present(to: TPSMainMenuScene())
        
    }
    
    override func sceneDidAppear() {
        (self.gkViewContoller as! GameViewController).showingScene = .sandbox
    }
}

extension TPSandBoxRootScene: TPSandBoxRootSceneModelBinder {}
