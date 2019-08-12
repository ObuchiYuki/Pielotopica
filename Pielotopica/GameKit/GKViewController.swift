//
//  GKViewController.swift
//  TPStartScene
//
//  Created by yuki on 2019/07/05.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit
import SceneKit

// =============================================================== //
// MARK: - GKGameViewController -

public class GKGameViewController:UIViewController {
    // =============================================================== //
    // MARK: - Properties -
    /// 現在のSKViewです。
    var scnView:SCNView {
        return self.view as! SCNView
    }
    
    // =============================================================== //
    // MARK: - Methods -
    override public func loadView() {
        super.loadView()
            
        if !(self.view is SCNView) { // IB Check
            self.view = SCNView()
        }
        
    }
    
    public func presentScene(with sceneHolder:GKSceneHolder, with transition:SKTransition? = nil) {
        if let scene3d = sceneHolder.generate3DBackgronudScene() {
            if let transition = transition {
                self.scnView.present(scene3d, with: transition, incomingPointOfView: nil, completionHandler: nil)
            }else{
                self.scnView.scene = scene3d
            }
        }else{
            self.scnView.scene = SCNScene()
        }
        
        if let scenebackground = sceneHolder.generateBackgronudScene() {
            self.scnView.overlaySKScene = scenebackground
        }else{
            self.scnView.overlaySKScene = SKScene();
        }
        
        self.scnView.overlaySKScene?.size = GKSafeScene.sceneSize
        self.scnView.overlaySKScene?.scaleMode = .aspectFill
        
        let safeScene = sceneHolder.generateSafeScene()
        safeScene.gameViewContoller = self
        let rootNode = safeScene.rootNode
        rootNode.removeFromParent()
        
        rootNode.size = GKSafeScene.sceneSize
        rootNode.position = GKSafeScene.sceneSize.point / 2
        
        let rootNodeScale = _calculateRootNodeScale(with: UIScreen.main.bounds.size)
        rootNode.setScale(rootNodeScale)
        
        self.scnView.overlaySKScene?.addChild(rootNode)
        
    }
    
    private func _calculateRootNodeScale(with viewSize:CGSize) -> CGFloat {
        
        let estimatedBGScale = GKSafeScene.sceneSize.aspectFillRatio(to: viewSize)
        let rootNodeScale = GKSafeScene.sceneSize.aspectFitRatio(to: viewSize) * (1 / estimatedBGScale)
        
        return rootNodeScale
    }
}
