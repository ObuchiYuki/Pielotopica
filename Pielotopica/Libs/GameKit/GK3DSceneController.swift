//
//  GK3DSceneController.swift
//
//  Created by yuki on 2019/05/09.
//  Copyright © 2019 yuki. All rights reserved.
//

import SceneKit
import SpriteKit

/**
 GK3DSceneControllerはSCNSceneの管理を提供します。
 */
open class GK3DSceneController :NSObject {
    // ================================================================================ //
    // MARK: - Properties -
    
    /// 管理するシーンです。もし異なるSCNSceneを使用する場合は
    /// loadSceneをオーバーライドして読み込んでください。
    public var scene:SCNScene!
    
    /// Sceneの基底ノードです。
    public var rootNode:SCNNode {
        return scene.rootNode
    }
    
    /// 親のSCNViewです。（参照は保持していません。）
    public var scnView:SCNView {
        return gkViewController.scnView
    }
    
    // ================================================================ //
    // MARK: - Default Nodes -
    
    /// Sceneのカメラです。
    /// ノードとしてのカメラは、ESSceneController.cameraNodeに格納されます。
    public lazy var camera = SCNCamera()
    
    /// Sceneの環境光です。
    /// ノードとしてのライトは、ESSceneController.ambientLightNodeに格納されます。
    public lazy var ambientLight:SCNLight = {
        let light = SCNLight()
        
        light.type = .ambient
        light.color = UIColor.lightGray
        
        return light
    }()
    
    public lazy var directionalLight:SCNLight = {
        let light = SCNLight()
        
        light.type = .directional
        light.color = UIColor.lightGray
        
        return light
    }()
    
    /// Sceneのカメラです。初期位置は`SCNVector3.zero`です。
    public lazy var cameraNode:SCNNode = {
        let cameraNode = SCNNode()
        cameraNode.camera = self.camera
        cameraNode.position = .zero
        return cameraNode
    }()
    
    /// Sceneの指向性ライトです。初期位置は`[0, 10, 10]`です。
    public lazy var directionalLightNode:SCNNode = {
        let lightNode = SCNNode()
        let light = self.directionalLight
        
        light.type = .directional
        light.color = UIColor.white
        
        lightNode.light = light
        lightNode.position = [0, 10, 0]
        lightNode.eulerAngles = [-.pi/7, .pi/4, 0]
        return lightNode
    }()
    
    /// Sceneの環境ライトノードです。初期位置は`.zero`です。
    public lazy var ambientLightNode:SCNNode = {
        let ambientLightNode = SCNNode()
        
        ambientLightNode.light = self.ambientLight
        return ambientLightNode
    }()
    
    // ================================================================================ //
    // MARK: - Private Properties
    /// 親のESViewControllerです。（参照は保持していません。）
    public weak var gkViewController:GKGameViewController!
    
    /// update更新用の`DisplayLink`です。
    private lazy var _displayLink = CADisplayLink(target: self, selector: #selector(GK3DSceneController._update(displayLink:)))
    
    // ========================================= //
    // MARK: - Flag -
    /// viewDidAppear用
    private var _firstDidAppearFlag = false
    /// viewWillAppear用
    private var _firstWillAppearFlag = false
    
    // ================================================================================ //
    // MARK: - Methods
    
    /// 3DSceneがタッチに反応する必要があるかどうかです。
    public func shouldRespondToTouch(at point:CGPoint) -> Bool {
        return gkViewController.should3DSceneRespondToTouch(at: point, isMoving: isMoving)
    }
    
    public func addGestureRecognizer(_ gestureRecognizer:UIGestureRecognizer) {
        self.gkViewController.scnView.addGestureRecognizer(gestureRecognizer)
    }
    public func removeGustureRecognizer(_ gestureRecognizer:UIGestureRecognizer) {
        self.gkViewController.scnView.removeGestureRecognizer(gestureRecognizer)
    }
    
    // ============================================================== //
    // MARK: - Handler Methods -
    
    @objc private func _update(displayLink: CADisplayLink) {
        // 毎フレーム呼び出し。
        self.update(displayLink.duration)
    }
    
    // ============================================================== //
    // MARK: - Overridable Methods -
    
    // ===================================== //
    // MARK: - Scene Constructing Methods -
    /// scene初期化前に呼び出されます。まだsceneはnilです。
    open func sceneWillLoad(){}
    
    /// sceneを初期化します。カスタマイズのSceneをセットする場合は、overrideして使用してください。
    open func loadScene(){
        self.scene = SCNScene()
    }
    /// scene初期化後に呼び出されます。sceneにはSCNSceneが代入されています。
    open func sceneDidLoad(){}
    
    /// scene表示前に呼び出されます。
    open func sceneWillAppear() {}
    
    /// scene表示後に呼び出されます。
    open func sceneDidAppear() {}
    
    /// scene非表示後に呼び出されます。
    open func sceneDidDisappear() {}
    
    // ===================================== //
    // MARK: - Rendering Methods -
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
    
    /// 環境光・カメラなどを読み込みます。
    /// 独自に設定する場合は、オーバーライドしてください。
    open func loadDefaultObject() {
        self.rootNode.addChildNode(cameraNode)
        self.rootNode.addChildNode(directionalLightNode)
        self.rootNode.addChildNode(ambientLightNode)
    }
    
    // ============================================================== //
    // MARK: - Event Methods -
    
    // ===================================== //
    // MARK: - Contact -
    
    /// 物理体の接触判定開始時に呼び出されます。
    open func didContactStart(nodeA:SCNNode, nodeB:SCNNode) {}
    /// 物理体の接触判定中に毎フレーム呼び出されます。
    open func didContacting(nodeA:SCNNode, nodeB:SCNNode) {}
    /// 物理体の接触判定終了時に呼び出されます。
    open func didContactEnd(nodeA:SCNNode, nodeB:SCNNode) {}
    
    
    // ===================================== //
    // MARK: - Hit Test -
    
    /// タッチによるヒットテスト判定が完了した時に呼び出されます。
    open func hitTestDidEnd(_ results:[SCNHitTestResult]) {}
    
    // ===================================== //
    // MARK: - Touch Handler -
    
    /// 画面へのタッチ開始時に呼び出されます。
    open func touchesBegan(at locations:[CGPoint]) {}
    
    /// 画面へのタッチが動いている時に呼び出されます。
    open func touchesMoved(at locations:[CGPoint]) {}
    
    /// 画面へのタッチが完了した時に呼び出されます。
    open func touchesEnd(at locations:[CGPoint]) {}
    
    /// 画面へのタッチが中断された場合に呼び出されます。(電話がかかってきた、急に電源が切られた。)
    open func touchesCanceled(at locations:[CGPoint]) {
        touchesEnd(at: locations)
    }
    
    // ================================================================================ //
    // MARK: - Constructor -
    
    /// GKGameViewConttollerを読み込みます。
    /// init 前に必ず呼び出してください。
    func _loadParentViewController(_ gkViewController: GKGameViewController) {
        self.gkViewController = gkViewController
        
        // scene読み込み
        self.sceneWillLoad()
        self.loadScene()
        self.sceneDidLoad()
            
        // update処理
        self._displayLink.add(to: .main, forMode: .common)
        
        // Defaultノード読み込み
        self.loadDefaultObject()
    }
    
    deinit {
        self.sceneDidDisappear()
        // update呼び出し解除
        self._displayLink.remove(from: .main, forMode: .common)
    }
}

// ================================================================================ //
// MARK: - Extension for SCNSceneRendererDelegate -
extension GK3DSceneController: SCNSceneRendererDelegate{
    public func renderer(_ renderer: SCNSceneRenderer, didApplyAnimationsAtTime time: TimeInterval) {
        self.didAnimationRendered()
    }
    public func renderer(_ renderer: SCNSceneRenderer, didSimulatePhysicsAtTime time: TimeInterval) {
        self.didSimulatePhysics()
    }
    public func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        if !_firstWillAppearFlag {
            _firstWillAppearFlag = true
            assert(gkViewController != nil, "GK3DSceneController._loadParentViewController must be called before load scene.")
            self.sceneDidAppear()
        }
        self.willRenderScene()
    }
    public func renderer(_ renderer: SCNSceneRenderer, didRenderScene scene: SCNScene, atTime time: TimeInterval) {
        if !_firstDidAppearFlag {
            _firstDidAppearFlag = true
            self.sceneDidAppear()
        }
        self.didRenderScene()
    }
}
