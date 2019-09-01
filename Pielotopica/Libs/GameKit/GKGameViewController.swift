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
public class GKGameViewController: UIViewController {
    // =============================================================== //
    // MARK: - Properties -
    /// 現在のSKViewです。
    var scnView:SCNView {
        return self.view as! SCNView
    }
    
    var skView = SKView()
    
    /// 現在のSafeSceneです。
    private var safeScene:GKSafeScene!
    private var background3dSceneController:GK3DSceneController?
        
    // =============================================================== //
    // MARK: - Methods -
    override public func loadView() {
        super.loadView()
            
        if !(self.view is SCNView) { // もしIBで設定済みだった場合。
            self.view = SCNView()
        }
        
        skView.allowsTransparency = true
        skView.backgroundColor = .clear
        skView.frame.size = self.view.frame.size
        self.view.addSubview(skView)
        
        let scene = SKScene(size: [375, 700])
        scene.backgroundColor = .clear
    }
    
    /// Sceneを変更します。
    /// sceneHolderにSceneを渡してください。
    public func presentScene(with sceneHolder: GKSceneHolder, with transition:SKTransition? = nil, _ completion: (()->Void)? = {}) {
        _load3DScene(sceneHolder, with: transition, completion)
        _loadBackgroundScene(sceneHolder)
        _loadSafeScene(sceneHolder)
    }
    
    public func runRayTrace(with location: CGPoint) {
        let hitResults = scnView.hitTest(location, options: [:])
        
        self.background3dSceneController?.hitTestDidEnd(hitResults)
    }

    /// 3DSceneがタッチに反応する必要があるかどうかです。
    public func should3DSceneRespondToTouch(at point:CGPoint) -> Bool {
        
        return _nodesOnTouch.isEmpty && _nodesOnOverlayScene(at: point) == nil
    }

    //==================================================================
    // MARK: - UIResponder Override Metheods -

    /// 現在タッチ中のノードです。
    private var _nodesOnTouch = [SKNode]()
    
    /// OverlayのノードのうちneedsHandleReactionがtrueのものを返します。
    private func _nodesOnOverlayScene(at point:CGPoint) -> SKNode? {
        guard let ps = skView.scene?.convertPoint(fromView: point) else {return nil}
        
        return skView.scene?.nodes(at: ps).first{$0.needsHandleReaction}
    }
    
    /// 2D画面が被さってた場合は、2Dに通知、そうでなければ3Dに通知
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: scnView) else { return }
        let node = _nodesOnOverlayScene(at: point)
        
        if let node = node {
            node.touchesBegan(touches, with: event)
            _nodesOnTouch.append(node)
            return
        }
        
        touchesBegan3D(touches, with: event)
    }
    
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if _nodesOnTouch.isEmpty {
            touchesMoved3D(touches, with: event)
        }else{
            _nodesOnTouch.forEach{$0.touchesMoved(touches, with: event)}
        }
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if _nodesOnTouch.isEmpty {
            touchesEnded3D(touches, with: event)
        }else{
            _nodesOnTouch.forEach{$0.touchesEnded(touches, with: event)}
            _nodesOnTouch = []
        }

    }
    
    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
    
    // =============================================================== //
    // MARK: - Private Methods -
    private func touchesBegan3D(_ touches: Set<UITouch>, with event: UIEvent?) {
        background3dSceneController?.touchesBegan(at: touches.compactMap{$0.location(in: scnView)})
    }
    
    private func touchesMoved3D(_ touches: Set<UITouch>, with event: UIEvent?) {
        background3dSceneController?.touchesMoved(at: touches.compactMap{$0.location(in: scnView)})
    }
    
    private func touchesEnded3D(_ touches: Set<UITouch>, with event: UIEvent?) {
        background3dSceneController?.touchesEnd(at: touches.compactMap{$0.location(in: scnView)})
    }
    
    /// SCNSceneを読み込みます。SKTransitionつけれます。
    private func _load3DScene(_ sceneHolder:GKSceneHolder, with transition:SKTransition?, _ completion: (()->Void)?) {
        
        if let scene3dController = sceneHolder.generate3DBackgronudScene() {
            scene3dController._loadParentViewController(self)
            _realPresentScene(to: scene3dController.scene, with: transition, completion)
            
            self.background3dSceneController = scene3dController
        }else{
            /// なければ新規作成
            _realPresentScene(to: SCNScene(), with: transition, completion)
        }
    }
    
    /// 背景シーンを読み込みます。
    private func _loadBackgroundScene(_ sceneHolder:GKSceneHolder) {
        if let scenebackground = sceneHolder.generateBackgronudScene() {
            skView.presentScene(scenebackground)
        }else{
            skView.presentScene(SKScene())
            skView.scene?.backgroundColor = .clear
        }
        
        skView.scene?.isUserInteractionEnabled = false
        skView.scene?.size = GKSafeScene.sceneSize
        skView.scene?.scaleMode = .aspectFill
    }
    
    /// UIシーンを読み込みます。
    private func _loadSafeScene(_ sceneHolder:GKSceneHolder) {
        safeScene = sceneHolder.generateSafeScene()
        safeScene.gkViewContoller = self
        
        let rootNode = safeScene.rootNode

        _loadRootNode(rootNode)
    }
    
    /// RootNodeのサイズ変化などを行い読み込みます。・
    private func _loadRootNode(_ rootNode:SKSpriteNode) {
        rootNode.removeFromParent()
        rootNode.name = "root"
        
        rootNode.isUserInteractionEnabled = false
        rootNode.size = GKSafeScene.sceneSize
        rootNode.position = GKSafeScene.sceneSize.point / 2
        
        let rootNodeScale = _calculateRootNodeScale(with: UIScreen.main.bounds.size)
        rootNode.setScale(rootNodeScale)
        
        skView.scene?.addChild(rootNode)
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
    #if DEBUG
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        GKGameViewController._debug = self
    }
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        GKGameViewController._debug = self
    }
    
    static var _debug:GKGameViewController? = nil
    #endif
}

extension GKGameViewController {
    #if DEBUG
    func showMessage(_ message:String) {
        let size = UIScreen.main.bounds.size
        let view = UIView(frame: CGRect(origin: [0, size.height - 50], size: [size.width, 50]))
        view.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        let label = UILabel(frame: [0, 0, size.width, 50])
        label.text = "\(message)-\(Date())"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 10)
        label.numberOfLines = -1
        label.textColor = .white
        view.addSubview(label)
        self.view.addSubview(view)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+3, execute: {
            view.removeFromSuperview()
        })
    }
    #endif
}
