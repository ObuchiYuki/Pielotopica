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
    // MARK: - Global -
    let header = TPHeader()
    
    var currentScene:TPSandBoxScene = TPSMainMenuScene()
    
    private let bag = DisposeBag()
    
    func present(to scene: TPSandBoxScene) {
        scene.show()
        self.addChild(scene.rootNode)
        currentScene.hide {
            self.currentScene.rootNode.removeFromParent()
        }

        currentScene = scene

    }
    
    // =============================================================== //
    // MARK: - Methods -
    override func sceneDidLoad() {

        self.rootNode.addChild(header)
    }
    
    override func sceneDidAppear() {
        (self.gkViewContoller as! GameViewController).showingScene = .sandbox
    }
}
