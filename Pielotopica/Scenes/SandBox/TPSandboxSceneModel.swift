//
//  TPSandboxSceneModel.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/06.
//  Copyright © 2019 yuki. All rights reserved.
//

import SceneKit
import RxSwift
import RxCocoa

/// ここら辺はRxSwiftの書きやすさより処理速度優先なので
protocol TPSandboxSceneModelBinder: class {
    
    // MARK: - datasource -
    /// カメラノードの場所を返してください。
    var __cameraPosition:SCNVector3 { get }
    
    // MARK: - Level -
    /// ノードを設置してください。
    func __placeNode(_ block:SCNNode, at position:TSVector3)
    /// ノードを動かしてください。
    func __moveNode(_ node:SCNNode, to position:TSVector3)
    /// ノードを削除してください。
    func __removeNode(_ node:SCNNode)
    
    // MARK: - Particles -
    func __addParticle(_ particle:SCNParticleSystem, to node:SCNNode)
    
    // MARK: - Camera -
    func __moveCamera(to position:SCNVector3)
    func __zoomCamera(to scale:Double)
    
}

/// ゲームシステムとの仲介役です。
/// イベントを受け取って管理します。
class TPSandboxSceneModel {
    
    static weak var initirized:TPSandboxSceneModel?
    
    // ================================================================== //
    // MARK: - Properties -
    
    internal var itemBarInventory:TSItemBarInventory {
        return TSPlayer.him.itemBarInventory
    }
    
    // =============================== //
    // MARK: - System Connection -
    
    // MARK: - Public -
    public var isPlacingBlockMode = BehaviorRelay(value: false)
    public var canEnterBlockPlaingMode:Bool {
        return uiSceneModel.mode == .buildMove || uiSceneModel.mode == .buildPlace
    }
    
    // MARK: - Private -
    
    // - Level -
    private let level = TSLevel.current()
    internal lazy var nodeGenerator = TSNodeGenerator(level: level)
    
    // - Binder -
    private weak var binder:TPSandboxSceneModelBinder!
    
    // - Helper -
    public var blockEditHelper:TPBlockEditHelper?
    private lazy var cameraGestutreHelper = TPSandboxCameraGestureHelper(delegate: self)
    
    /// 現在のドラッグを受け取る状態です。
    private var dragControleState:DragControleState = .cameraMoving
    
    private enum DragControleState{
        case blockPlacing
        case cameraMoving
    }
    
    private var uiSceneModel:TPSandBoxSceneUIModel {
        return TPSandBoxSceneUIModel.initirized!
    }
    // ================================================================== //
    // MARK: - Methods -
    
    /// ピンチジェスチャーで呼び出してください。
    func onPinchGesture(with scale:CGFloat) {
        cameraGestutreHelper.pinched(to: scale)
    }
    
    /// パンジェスチャーで呼び出してください。
    func onPanGesture(with vector:CGPoint, at velocity:CGPoint, numberOfTouches:Int) {
        switch dragControleState {
        case .blockPlacing:
            if numberOfTouches != 1 { // もし途中で変わったら変更する。
                dragControleState = .cameraMoving
                return 
            }
            blockEditHelper?.onDrag(at: vector)
        case .cameraMoving:
            cameraGestutreHelper.panned(to: vector, at: velocity)
        }
    }
    
    /// タップジェスチャーで呼び出してください。
    func onTapGesture() {
        guard canEnterBlockPlaingMode else { return }
        
        if isPlacingBlockMode.value {
            guard let blockEditHelper = blockEditHelper else {return}
            
            if blockEditHelper.canEndBlockEditing() {
                blockEditHelper.endBlockEditing()
                
                _blockPositionDidDecided(blockEditHelper)
                
                dragControleState = .cameraMoving // 元にもどす
            }
        }
    }
    
    /// タッチ開始時に呼び出してください。
    func onTouchStart(at point:CGPoint, numberOfTouches:Int) {

        // モード設定
        if isPlacingBlockMode.value && numberOfTouches == 1 {
            self.dragControleState = .blockPlacing
        }else {
            self.dragControleState = .cameraMoving
        }
        
        // 動作
        switch dragControleState {
        case .blockPlacing:
            blockEditHelper?.onTouchBegan()
            
        case .cameraMoving:
            let cameraPosition = binder.__cameraPosition
            cameraGestutreHelper.onTouch(cameraStartedAt: cameraPosition)
        }
        
    }
    
    /// ヒットテストが終わったら呼び出してください。
    func hitTestDidEnd(at worldCoordinate:TSVector3, touchedNode:SCNNode) {
        guard canEnterBlockPlaingMode else { return }
        
        var worldCoordinate = worldCoordinate
        if worldCoordinate.y16 < 1 {
            worldCoordinate.y16 = 1
        }
        
        if uiSceneModel.mode == .buildPlace {
            if itemBarInventory.canUseCurrentItem() {
                guard let block = (itemBarInventory.selectedItemStack.item as? TSBlockItem)?.block else { return }
                
                _startBlockEditing(from: worldCoordinate, block: block, moving: false)
            }
        }else if uiSceneModel.mode == .buildMove {
            let anchorPoint = TSVector3(touchedNode.worldPosition)
            let block = level.getAnchorBlock(at: anchorPoint)
            
            guard block.canDestroy(at: anchorPoint) else {return}
            
            binder.__removeNode(touchedNode)
            
            _startBlockEditing(from: anchorPoint, block: block, moving: true)
        }
    }
    
    private func _startBlockEditing(from startPoint:TSVector3, block:TSBlock, moving:Bool) {
        isPlacingBlockMode.accept(true)
        dragControleState = .blockPlacing
        
        if moving {
            let _blockMoveHelper = TPBlockMoveHelper(delegate: self, block: block)
            _blockMoveHelper.startMoving(at: startPoint)
            
            self.blockEditHelper = _blockMoveHelper
        }else{
            let _blockPlaceHelper = TPBlockPlaceHelper(delegate: self, block: block)
            _blockPlaceHelper.startBlockPlacing(at: startPoint)
            
            self.blockEditHelper = _blockPlaceHelper
        }
    }

    
    func sceneDidLoad() {
        level.delegate = self
        /// 床設置 (仮)
        for x in -2...2 {
            for z in -2...2 {
                
                if abs(x) == 2 || abs(z) == 2 {
                    level.placeBlock(.ground5x5Edge, at: TSVector3(x * 5, 0, z * 5), rotation: .x0, forced: true)
                }else {
                    level.placeBlock(.ground5x5, at: TSVector3(x * 5, 0, z * 5), rotation: .x0, forced: true)
                }
            }
        }
    }
    

    // ================================================================== //
    // MARK: - Private Methods -
    
    /// ブロックの設置場所が確定したら呼び出してください。
    private func _blockPositionDidDecided(_ helper:TPBlockEditHelper) {
        self.isPlacingBlockMode.accept(false)
        self.itemBarInventory.useCurrentItem()
        
        RMTapticEngine.impact.feedback(.heavy)
    }
    // ================================================================== //
    // MARK: - Constructor -
    
    init(_ binder:TPSandboxSceneModelBinder) {
        self.binder = binder
        TPSandboxSceneModel.initirized = self
    }
}


// ================================================================== //
// MARK: - Extension for TPBlockPlaceHelperDelegate -
extension TPSandboxSceneModel: TPBlockEditHelperDelegate {
    func blockEditHelper(placeGuideNodeWith node: SCNNode, at position: TSVector3) {
        binder.__placeNode(node, at: position)
    }
    func blockEditHelper(endBlockPlacingWith node: SCNNode) {
        binder.__removeNode(node)
    }
    func blockEditHelper(moveNodeWith node:SCNNode, to position: TSVector3) {
        binder.__moveNode(node, to: position)
    }
}

// ================================================================== //
// MARK: - Extension for TPCameraGestureHelperDelegate -
extension TPSandboxSceneModel: TPCameraGestureHelperDelegate{
    func cameraGestureHelper(_ cameraGestureHelper: TPSandboxCameraGestureHelper, cameraDidMoveTo position: SCNVector3) {
        binder.__moveCamera(to: position)
    }
    func cameraGestureHelper(_ cameraGestureHelper: TPSandboxCameraGestureHelper, cameraDidchangeZoomedTo scale: Double) {
        binder.__zoomCamera(to: scale)
    }
}

// ================================================================== //
// MARK: - Extension for TSLevelDelegate -
extension TPSandboxSceneModel : TSLevelDelegate {
    func level(_ level: TSLevel, levelDidUpdateBlockAt position: TSVector3) {
        guard let node = nodeGenerator.getNode(for: position) else {return}
        
        if level.getAnchorBlock(at: position).shouldAnimateWhenPlaced(at: position) {
            let action = TSBlockAnimator.generateBlockPlaceAnimation(for: node)
            node.runAction(action)
        }
        
        let rotation = TSBlockRotation(data: level.getBlockData(at: position))
        node.eulerAngles = SCNVector3(0, rotation.eulerAngle , 0)
        
        let nodePosition = position + rotation.nodeModifier
        
        binder.__placeNode(node, at: nodePosition)
    }
    func level(_ level: TSLevel, levelDidDestoryBlockAt position: TSVector3) {
        guard let node = nodeGenerator.getNode(for: position) else {return}
        
        binder.__removeNode(node)
    }
}
