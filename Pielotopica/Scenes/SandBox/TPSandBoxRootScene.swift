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
    
    private let sceneMode = TPSandBoxRootSceneModel.shared
    
    var currentScene:TPSandBoxScene!
    
    
    // =============================================================== //
    // MARK: - Methods -
    func present(to scene: TPSandBoxScene) {
        sceneMode.onSceneChanged(to: scene)
        
        scene.show()
        scene.gkViewContoller = self.gkViewContoller
        
        self.rootNode.addChild(scene.rootNode)
        
        currentScene?.hide {
            self.currentScene.rootNode.removeFromParent()
        }

        currentScene = scene
    }
    
    override func sceneDidLoad() {

        self.sceneModel.binder = self
        self.rootNode.addChild(header)
        
        self.present(to: TPSMainMenuScene())
    }
    
    override func sceneDidAppear() {
        (self.gkViewContoller as! GameViewController).showingScene = .sandbox
    }
}

extension TPSandBoxRootScene: TPSandBoxRootSceneModelBinder {}
