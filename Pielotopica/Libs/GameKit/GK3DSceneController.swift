//
//  GK3DSceneController.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/12.
//  Copyright © 2019 yuki. All rights reserved.
//

import UIKit
import SceneKit
import SpriteKit


/// GK3DSceneControllerはSCNSceneの管理を提供します。
/// 継承して使うことを想定しています。
/// initにGKGameViewControllerを使いますが、参照を保持しません。
/// - sceneWillLoad()
/// はscene初期化前に呼び出されます。まだsceneはnilです。
/// - sceneDidLoad()
/// はscene初期化後に呼び出されます。sceneにはSCNSceneが代入されています。
open class GK3DSceneController: UIResponder {
    // ================================================================
    // MARK: - Properties
    /// 管理するシーンです。もし異なるSCNSceneを使用する場合は
    public var scene:SCNScene!
    
    /// Sceneの基底ノードです。
    public var rootNode:SCNNode {
        return scene.rootNode
    }
    
    /// Sceneのカメラです。初期位置は`SCNVector3.zero`です。
    public var camera:SCNNode = {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = .zero
        return cameraNode
    }()
    
    /// Sceneの指向性ライトです。初期位置は`[0, 100, 100]`です。
    public var lightNode:SCNNode = {
        let lightNode = SCNNode()
        let light = SCNLight()
        
        light.type = .omni
        light.color = UIColor.white
        
        lightNode.light = light
        lightNode.position = [0, 10, 10]
        return lightNode
    }()
    
    /// Sceneの環境ライトです。初期位置は`.zero`です。
    public var ambientLightNode:SCNNode = {
        let ambientLightNode = SCNNode()
        let light = SCNLight()
        
        light.type = .ambient
        light.color = UIColor.lightGray
        
        ambientLightNode.light = light
        return ambientLightNode
    }()
    
    // ================================================================
    // MARK: - Private Properties
    /// 親のSCNViewです。
    private weak var _esViewController:GKGameViewController!
    
    // update更新用の`DisplayLink`です。
    private lazy var _displayLink:CADisplayLink = CADisplayLink(target: self, selector: #selector(_update(displayLink:)))
    
    // ================================================================
    // MARK: - Methods
    
    // ===============================
    // MAARK: - Overridable Methods
    
    /// scene初期化前に呼び出されます。まだsceneはnilです。
    open func sceneWillLoad(){}
    
    /// sceneを初期化します。カスタマイズのSceneをセットする場合は、overrideして使用してください。
    open func loadScene(){
        self.scene = SCNScene()
    }
    /// scene初期化後に呼び出されます。sceneにはSCNSceneが代入されています。
    open func sceneDidLoad(){}
    
    /// シーンのアップデート時に呼び出されます。
    /// この処理は描画毎に常に呼び出されます。
    open func update(_ duration:Double) {}
    
    /// 毎フレームのアニメーション処理完了後に呼び出されます。
    /// この処理は処理がある時のみ呼ばれます。
    open func didAnimationRendered() {}
    
    /// 毎フレームの物理演算完了後に呼び出されます。
    /// この処理は処理がある時のみ呼ばれます。
    open func didSimulatePhysics() {}
    
    /// 毎フレームの描画直前に呼び出されます。
    /// この処理は処理がある時のみ呼ばれます。
    open func willRenderScene() {}
    
    /// 毎フレームの描画直後に呼び出されます。
    /// この処理は処理がある時のみ呼ばれます。
    open func didRenderScene() {}
    
    open func didContactStart(nodeA:SCNNode, nodeB:SCNNode) {}
    open func didContacting(nodeA:SCNNode, nodeB:SCNNode) {}
    open func didContactEnd(nodeA:SCNNode, nodeB:SCNNode) {}
    
    /// 初期化します。
    internal func _startloading(_ esViewController: GKGameViewController) {
        // メンバー初期化
        self._esViewController = esViewController
                
        // scene読み込み
        self.sceneWillLoad()
        self.loadScene()
        self.sceneDidLoad()
        
        self._esViewController.scnView.scene = scene
        self._esViewController.scnView.delegate = self
        
        self.scene.physicsWorld.contactDelegate = self
        
        // update処理
        self._displayLink.add(to: .main, forMode: .common)
        
        // Defaultノード読み込み
        self.rootNode.addChildNode(camera)
        self.rootNode.addChildNode(lightNode)
        self.rootNode.addChildNode(ambientLightNode)
    }
    
    deinit {
        self._displayLink.remove(from: .main, forMode: .common)
    }

    @objc private func _update(displayLink: CADisplayLink) {
        
        self.update(displayLink.duration)
    }
}

extension GK3DSceneController: SCNSceneRendererDelegate{
    public func renderer(_ renderer: SCNSceneRenderer, didApplyAnimationsAtTime time: TimeInterval) {
        self.didAnimationRendered()
    }
    public func renderer(_ renderer: SCNSceneRenderer, didSimulatePhysicsAtTime time: TimeInterval) {
        self.didSimulatePhysics()
    }
    public func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        self.willRenderScene()
    }
    public func renderer(_ renderer: SCNSceneRenderer, didRenderScene scene: SCNScene, atTime time: TimeInterval) {
        self.didRenderScene()
    }
}

extension GK3DSceneController: SCNPhysicsContactDelegate {
    public func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        self.didContactStart(nodeA: contact.nodeA, nodeB: contact.nodeB)
    }
    public func physicsWorld(_ world: SCNPhysicsWorld, didUpdate contact: SCNPhysicsContact) {
        self.didContacting(nodeA: contact.nodeA, nodeB: contact.nodeB)
    }
    public func physicsWorld(_ world: SCNPhysicsWorld, didEnd contact: SCNPhysicsContact) {
        self.didContactEnd(nodeA: contact.nodeA, nodeB: contact.nodeB)
    }
}

