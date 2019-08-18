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

/// ゲーム画面を管理する基本のViewControllerです。
/// 3D, 2DどちらのSceneも表示することができます。
/// InterfaceBuilderを組み合わせることも可能です。
/// その場合、viewはSCNViewに設定してください。
public class GKGameViewController: UIViewController {
    // =============================================================== //
    // MARK: - Properties -
    /// 現在のSKViewです。
    var scnView:SCNView {
        return self.view as! SCNView
    }
    
    /// 現在のSafeSceneです。
    private var safeScene:GKSafeScene!
    
    // =============================================================== //
    // MARK: - Methods -
    override public func loadView() {
        super.loadView()
            
        if !(self.view is SCNView) { // もしIBで設定済みだった場合。
            self.view = SCNView()
        }
        
    }
    
    /// Sceneを変更します。
    /// sceneHolderにSceneを渡してください。
    public func presentScene(with sceneHolder: GKSceneHolder, with transition:SKTransition? = nil, _ completion: (()->Void)? = {}) {
        _load3DScene(sceneHolder, with: transition, completion)
        _loadBackgroundScene(sceneHolder)
        _loadSafeScene(sceneHolder)
        
    }
    
    // =============================================================== //
    // MARK: - Private Methods -
    
    /// SCNSceneを読み込みます。SKTransitionつけれます。
    private func _load3DScene(_ sceneHolder:GKSceneHolder, with transition:SKTransition?, _ completion: (()->Void)?) {
        
        if let scene3dController = sceneHolder.generate3DBackgronudScene() {
            scene3dController._startloading(self)
            _realPresentScene(to: scene3dController.scene, with: transition, completion)
        }else{
            /// なければ新規作成
            _realPresentScene(to: SCNScene(), with: transition, completion)
        }
    }
    
    /// 背景シーンを読み込みます。
    private func _loadBackgroundScene(_ sceneHolder:GKSceneHolder) {
        if let scenebackground = sceneHolder.generateBackgronudScene() {
            self.scnView.overlaySKScene = scenebackground
        }else{
            self.scnView.overlaySKScene = SKScene();
            self.scnView.overlaySKScene?.backgroundColor = .clear
        }
        
        self.scnView.overlaySKScene?.size = GKSafeScene.sceneSize
        self.scnView.overlaySKScene?.scaleMode = .aspectFill
        
    }
    
    /// UIシーンを読み込みます。
    private func _loadSafeScene(_ sceneHolder:GKSceneHolder) {
        safeScene = sceneHolder.generateSafeScene()
        safeScene.gameViewContoller = self
        
        let rootNode = safeScene.rootNode

        _loadRootNode(rootNode)
    }
    
    /// RootNodeのサイズ変化などを行い読み込みます。・
    private func _loadRootNode(_ rootNode:SKSpriteNode) {
        rootNode.removeFromParent()
        rootNode.name = "root"
        
        rootNode.size = GKSafeScene.sceneSize
        rootNode.position = GKSafeScene.sceneSize.point / 2
        
        let rootNodeScale = _calculateRootNodeScale(with: UIScreen.main.bounds.size)
        rootNode.setScale(rootNodeScale)
        
        self.scnView.overlaySKScene?.addChild(rootNode)
    }
    
    /// 実際にシーンを変更します。
    private func _realPresentScene(to scene:SCNScene, with transition:SKTransition?, _ completion: (()->Void)?) {
        if let transition = transition {
            self.scnView.present(scene, with: transition, incomingPointOfView: nil, completionHandler: completion)
        }else{
            self.scnView.scene = scene
            completion?()
        }
    }
    
    private func _calculateRootNodeScale(with viewSize:CGSize) -> CGFloat {
        
        let estimatedBGScale = GKSafeScene.sceneSize.aspectFillRatio(to: viewSize)
        let rootNodeScale = GKSafeScene.sceneSize.aspectFitRatio(to: viewSize) * (1 / estimatedBGScale)
        
        return rootNodeScale
    }
}