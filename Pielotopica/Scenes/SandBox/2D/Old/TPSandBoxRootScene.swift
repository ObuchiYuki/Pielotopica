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
    // MARK: - Properties -
    
    // node
    private let header = TPHeader()
    private let timeBar = TSBattleTimer()
    
    // system
    private let sceneModel = TPSandBoxRootSceneModel.shared
    private var currentScene:TPSandBoxScene!
    
    private var _presentLock = false
    
    // =============================================================== //
    // MARK: - Methods -
    
    override func sceneDidLoad() {

        self.sceneModel.setBinder(self)
        self.rootNode.addChild(header)
    }
    
    override func sceneDidAppear() {
        (self.gkViewContoller as! GameViewController).showingScene = .game
        self.sceneModel.present(to: TPSMainMenuScene())
    }
    
    // =============================================================== //
    // MARK: - Private Methods -
    private func _showNewScene(with newScene:TPSandBoxScene,from oldMode: TPSandBoxRootSceneModel.Mode?) {
        // 初期化
        newScene.gkViewContoller = gkViewContoller
        self.rootNode.addChild(newScene.rootNode)
        
        newScene.show(from: oldMode)
    }
    
}

extension TPSandBoxRootScene: TPSandBoxRootSceneModelBinder {
    func __present(to scene: TPSandBoxScene, as mode: TPSandBoxRootSceneModel.Mode) -> Bool {
        // lock 機構
        guard !_presentLock else { return false }; _presentLock = true
        
        // show
        _showNewScene(with: scene, from: currentScene?.__sceneMode)
        
        // hide
        if let currentScene = currentScene {
            currentScene.hide(to: mode) { [currentScene] in
                self._presentLock = false
                currentScene.rootNode.removeFromParent()
            }
        } else { self._presentLock = false }

        currentScene = scene
        
        return true
    }
}
