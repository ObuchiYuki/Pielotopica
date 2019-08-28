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
    
    private let sceneMode = TPSandBoxRootSceneModel.shared
    
    var currentScene:TPSandBoxScene!
    
    func present(to scene: TPSandBoxScene) {
        sceneMode.onSceneChanged(to: scene)
        
        scene.show()
        scene.gkViewContoller = self.gkViewContoller
        
        self.rootNode.addChild(scene.rootNode)
        
        currentScene.hide {
            self.currentScene.rootNode.removeFromParent()
        }

        currentScene = scene
    }
    
    // =============================================================== //
    // MARK: - Methods -
    override func sceneDidLoad() {

        self.rootNode.addChild(header)
        
        self.present(to: TPSMainMenuScene())
    }
    
    override func sceneDidAppear() {
        (self.gkViewContoller as! GameViewController).showingScene = .sandbox
    }
}
