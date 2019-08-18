//
//  GKSafeScene.swift
//  TPStartScene
//
//  Created by yuki on 2019/07/06.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

// =============================================================== //
// MARK: - GKSafeScene -

/// SafeAreaのみに表示されるSKSceneです。
/// UIはこのScene上に構成してください。全てのiPhoneで適切なサイズで表示されます。
/// Nodeの追加はrootNodeに対して行ってください。
public class GKSafeScene: SKScene {
    // =============================================================== //
    // MARK: - Properties -
    
    public var rootNode = SKSpriteNode()
    
    public weak var gameViewContoller:GKGameViewController!

    // =============================================================== //
    // MARK: - Methods -
    
    /// 次のシーンに切り替えます。
    func present(to sceneHalder: GKSceneHolder, delayed delay: TimeInterval = 0, with transition: SKTransition? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.gameViewContoller.presentScene(with: sceneHalder, with: transition)
            
        }
    }    
}

extension GKSafeScene {
    
    /// SceneのSriteKit上でのサイズは常時このサイズです。
    public static let sceneSize = CGSize(width: 375, height: 700)
}
