//
//  MySceneController.swift
//  SandboxSample
//
//  Created by yuki on 2019/05/31.
//  Copyright © 2019 yuki. All rights reserved.
//

import SceneKit
import RxSwift
import RxCocoa


class TPSandboxSceneController: GK3DSceneController {
    // ===================================================================== //
    // MARK: - Properies -
    
    public lazy var sceneModel = TPSandboxSceneModel(self)
    
    private let bag = DisposeBag()
    
    private lazy var pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
    private lazy var panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
    private lazy var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
    
    // ===================================================================== //
    // MARK: - Methods -
    
    override init() {
        super.init()
        #if DEBUG
        TPSandboxSceneController._debug = self
        #endif
    }
    
    // ================================ //
    // MARK: - Handler -
    @objc func handlePinchGesture(_ recognizer:UIPinchGestureRecognizer) {
        let scale = recognizer.scale
        
        sceneModel.onPinchGesture(with: scale)
    }
    
    @objc func handlePanGesture(_ recognizer:UIPanGestureRecognizer) {
        let point = recognizer.location(in: scnView)
        guard shouldRespondToTouch(at: point) else { return }
        
        let vector = recognizer.translation(in: scnView)
        let velocity = recognizer.velocity(in: scnView)
        
        sceneModel.onPanGesture(with: vector,at: velocity, numberOfTouches: recognizer.numberOfTouches)
    }
    @objc func handleTapGesture(_ recognizer:UITapGestureRecognizer) {
        let point = recognizer.location(in: scnView)
        guard shouldRespondToTouch(at: point) else { return }
        
        if !sceneModel.isPlacingBlockMode.value {
            gkViewController.runRayTrace(with: point)
            return
        }else{
            sceneModel.onTapGesture()
        }
    }

    // ================================ //
    // MARK: - Overrided -
    override func touchesBegan(at locations: [CGPoint]) {
        sceneModel.onTouchStart(at: locations[0], numberOfTouches: locations.count)
        
    }
    
    override func hitTestDidEnd(_ results: [SCNHitTestResult]) {
        guard let result = results.first else { return }
        let coordinate = result.worldCoordinates
        
        self.sceneModel.hitTestDidEnd(at: TSVector3(coordinate), touchedNode: result.node)
    }
    
    override func sceneDidLoad() {
        self.sceneModel.sceneDidLoad()
        
        self.addGestureRecognizer(pinchGestureRecognizer)
        self.addGestureRecognizer(panGestureRecognizer)
        self.addGestureRecognizer(tapGestureRecognizer)
        
        // Scene Settings
        self.setupSkybox()
        self.setupCamera()
        self.setupDirectionalLight()
        
        
    }
}

// ==================================================================================== //
// MARK: - Extension for SceneModel -

extension TPSandboxSceneController: TPSandboxSceneModelBinder {
    
    var __cameraPosition: SCNVector3 {
        return self.cameraNode.position
    }
    
    // - Level -
    func __placeNode(_ node:SCNNode, at position:TSVector3) {
        node.position = position.scnVector3
        
        self.rootNode.addChildNode(node)
    }
    func __moveNode(_ node:SCNNode, to position:TSVector3) {
        node.position = position.scnVector3
        
    }
    func __removeNode(_ node:SCNNode) {
        node.removeFromParentNode()
        
    }
    
    // - Particles -
    func __addParticle(_ particle: SCNParticleSystem, to node:SCNNode) {
        node.addParticleSystem(particle)
        
    }
    
    // - Camera -
    func __moveCamera(to position:SCNVector3) {
        self.cameraNode.position = position
        
    }
    func __zoomCamera(to scale:Double) {
        self.camera.orthographicScale = scale
        
    }
}

// ==================================================================================== //
// MARK: - Extension for Addtinal Methods -

extension TPSandboxSceneController {
    func setupDirectionalLight() {
        directionalLightNode.eulerAngles = [-.pi/4, -.pi/4, 0]
        
        directionalLight.castsShadow = true
        directionalLight.shadowMapSize = [1000, 1000]
        directionalLight.maximumShadowDistance = 2000
        directionalLight.shadowColor = UIColor.black.withAlphaComponent(0.8)
        directionalLight.shadowRadius = 3
        directionalLight.shadowSampleCount = 8
        
    }
    func setupCamera() {
        camera.usesOrthographicProjection = true
        camera.orthographicScale = 10
        
        camera.automaticallyAdjustsZRange = true
        camera.wantsExposureAdaptation = true
        
        camera.screenSpaceAmbientOcclusionRadius = 1
        camera.screenSpaceAmbientOcclusionIntensity = 1
        
        cameraNode.eulerAngles = [-.pi/6, .pi/4, 0]
        cameraNode.position = [102, 82, 97]
    }
    func setupSkybox() {
        self.scene.background.contents = [
            UIImage(named: "sky-0"),
            UIImage(named: "sky-1"),
            UIImage(named: "sky-2"),
            UIImage(named: "sky-3"),
            UIImage(named: "sky-4"),
            UIImage(named: "sky-5"),
        ]
    }
}
