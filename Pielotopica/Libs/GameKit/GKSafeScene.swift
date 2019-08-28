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
    
    public weak var gkViewContoller:GKGameViewController!

    // =============================================================== //
    // MARK: - Methods -
    
    func sceneDidAppear() {
        
    }
    
    /// 次のシーンに切り替えます。
    func present(to sceneHalder: GKSceneHolder, delayed delay: TimeInterval = 0, with transition: SKTransition? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.gkViewContoller.presentScene(with: sceneHalder, with: transition)
            
        }
    }
    
    public override func addChild(_ node: SKNode) {
        
        fatalError("You cannot add a node directly to GKSafeScene. Use rootNode instead.")
    }
    public override init() {
        super.init()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.01, execute: { self.sceneDidAppear() })
        
    }
    public override init(size: CGSize) {
        super.init(size: size)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.01, execute: { self.sceneDidAppear() })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension GKSafeScene {
    
    /// SceneのSriteKit上でのサイズは常時このサイズです。
    public static let sceneSize = CGSize(width: 375, height: 700)
}
