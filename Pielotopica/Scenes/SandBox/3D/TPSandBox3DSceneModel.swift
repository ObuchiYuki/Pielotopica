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
    
    // MARK: - Stage -
    func __makeNight()
    func __makeDay()
    
    // MARK: - Game - 
    func __startGame()
    func __endGame()
    
}

/// ゲームシステムとの仲介役です。
/// イベントを受け取って管理します。
class TPSandBox3DSceneModel {
    
    static weak var initirized:TPSandBox3DSceneModel?
    
    // ================================================================== //
    // MARK: - Properties -
    
    internal var itemBarInventory:TSItemBarInventory {
        return TSItemBarInventory.itembarShared
    }
    
    // =============================== //
    // MARK: - System Connection -
    
    // MARK: - Public -
    public var isPlacingBlockMode = BehaviorRelay(value: false)
    public var canEnterBlockPlaingMode = BehaviorRelay(value: false)
    
    // MARK: - Private -
    
    // - Level -
    private let manager = TSTerrainManager.shared
    private var editor = TSTerrainEditor.shared
    private var nodeGenerator = TSChunkNodeGenerator.shared
    
    // - Binder -
    private weak var binder:TPSandboxSceneModelBinder!
    
    // - Helper -
    public var blockEditHelper:TPBlockEditHelper?
    private lazy var cameraGestutreHelper = TPSandboxCameraGestureHelper(delegate: self)
    
    /// gesture
    private var dragControleState:DragControleState = .cameraMoving
    
    private enum DragControleState{
        case blockPlacing
        case cameraMoving
    }
    
    private var uiSceneModel:TPSandBoxRootSceneModel! {
        return TPSandBoxRootSceneModel.shared
    }
    
    private let bag = DisposeBag()
    // ================================================================== //
    // MARK: - Methods -
    
    func makeBattleMode() {
        binder.__makeNight()
        binder.__startGame()
    }
    
    func makeNormalMode() {
        binder.__makeDay()
        binder.__endGame()
    }
    
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
        if isPlacingBlockMode.value {
            _endBlockEditing(forced: false)
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
        
        let anchor = TSChunkNodeGenerator.shared.anchor(of: touchedNode)
        
        _ = TSTerrainManager.shared.chunk(contains: anchor.vector2)
        
        print(TSTerrainManager.shared.loadedChunks.map{$0.point}.count)
        
        touchedNode.illuminantRed()
        
        return
        
        guard !isPlacingBlockMode.value else { return }
        guard uiSceneModel.mode.value == .build else { return }
        
        let sceneModel = uiSceneModel.currentSceneModel as! TPSBuildSceneModel
        
        switch sceneModel.mode.value {
        case .place:
            if itemBarInventory.canUseCurrentItem() {
                guard let block = (itemBarInventory.selectedItemStack.item as? TSBlockItem)?.block else { return }
                
                let position = _modifyPosition(worldCoordinate)
                
                guard canEnterBlockPlaingMode.value else { return }
                _startBlockPlacing(from: position, block: block)
            }
        case .move:
            guard canEnterBlockPlaingMode.value else { return }
            
            _startBlockMoving(with: touchedNode)
        case .destory:
            
            _startBlockDestoring(with: touchedNode)
        }
    }
    
    func sceneDidLoad() {
        
        editor.delegates.append(self)
        
        manager.didPlayerMoved(to: .zero)
        
        binder.__makeDay()
        
        //if first luanch {
            _createStage1()
        //}
    }
    

    // ================================================================== //
    // MARK: - Private Methods -
    private func _createStage1() {
        /// 床設置 (仮)
        //for x in -20...20 {
        //    for z in -20...20 {
        //        editor.placeBlock(.ground5x5, at: TSVector3(5 * x, 0, 5 * z), rotation: .x0, forced: true)
        //    }
        //}
    }
    
    private func _endBlockEditing(forced:Bool) {
        guard let blockEditHelper = blockEditHelper else {return}
        
        if forced || blockEditHelper.canEndBlockEditing() {
            blockEditHelper.endBlockEditing()
            _blockPositionDidDecided(blockEditHelper)
            
            dragControleState = .cameraMoving // 元にもどす
        }
    }
    
    private func _onCanEnterBlockPlaingModeChange(to value:Bool) {
        if !value && isPlacingBlockMode.value {
            _endBlockEditing(forced: true)
        }
    }
    private func _modifyPosition(_ pos: TSVector3) -> TSVector3 {
        var pos = pos
        if pos.y16 < 1 {
            pos.y16 = 1
        }
        
        return pos
    }
    private func _startBlockDestoring(with touchedNode: SCNNode) {
        // get block
        let nodeRotationInt = Int(touchedNode.parent!.eulerAngles.y / (.pi/2))
        
        let nodeRotation = TSBlockRotation(rotation: nodeRotationInt)
        let anchor = TSVector3(touchedNode.worldPosition) - nodeRotation.nodeModifier
        let block = TSTerrainManager.shared.getAnchorBlock(at: anchor)
    
        // process
        guard block.canDestroy(at: anchor) else {
            TPBuildNotice.show(text: "このブロックは破壊できません。", color: TPCommon.Color.dangerous)
            return
        }
        
        let action = TSBlockAnimator.generateBlockDestroyAnimation(for: touchedNode) {
            self.binder.__removeNode(touchedNode)
        }
        touchedNode.runAction(action)
        
        block.dropItemStacks(at: anchor).forEach(itemBarInventory.addItemStack)
        
        editor.destoroyBlock(at: anchor)
    }
    
    private func _startBlockMoving(with touchedNode: SCNNode) {
        // get block
        let nodeRotationInt = Int(touchedNode.parent!.eulerAngles.y / (.pi/2))
        
        let nodeRotation = TSBlockRotation(rotation: nodeRotationInt)
        let anchorPoint = TSVector3(touchedNode.worldPosition) - nodeRotation.nodeModifier
        let block = TSTerrainManager.shared.getAnchorBlock(at: anchorPoint)
        
        // process
        guard block.canDestroy(at: anchorPoint) else {return}
        
        binder.__removeNode(touchedNode)
        
        _prepareBlockEditing()
        
        let _blockMoveHelper = TPBlockMoveHelper(delegate: self, block: block)
        _blockMoveHelper.startMoving(at: anchorPoint)
        
        self.blockEditHelper = _blockMoveHelper
    }
    
    private func _startBlockPlacing(from startPoint:TSVector3, block:TSBlock) {
        
        
        let _blockPlaceHelper = TPBlockPlaceHelper(delegate: self, block: block)
        let success = _blockPlaceHelper.startBlockPlacing(at: startPoint)
        
        if success {
            _prepareBlockEditing()
            self.blockEditHelper = _blockPlaceHelper
        }
    }
    
    private func _prepareBlockEditing() {
        isPlacingBlockMode.accept(true)
        dragControleState = .blockPlacing
    }
    /// ブロックの設置場所が確定したら呼び出してください。
    private func _blockPositionDidDecided(_ helper:TPBlockEditHelper) {
        self.isPlacingBlockMode.accept(false)
        
        if helper is TPBlockPlaceHelper { // 置く場合のみ
            self.itemBarInventory.useCurrentItem()
        }
        
        RMTapticEngine.impact.feedback(.heavy)
    }
    // ================================================================== //
    // MARK: - Constructor -
    
    init(_ binder:TPSandboxSceneModelBinder) {
        self.binder = binder
        TPSandBox3DSceneModel.initirized = self
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.01) {
            
            self.uiSceneModel.mode.subscribe{[unowned self] event in
                guard let mode = event.element, mode == .build else {
                    self.canEnterBlockPlaingMode.accept(false)
                    return
                }
                
                let sceneModel = self.uiSceneModel.currentSceneModel as! TPSBuildSceneModel
                
                sceneModel.mode.subscribe {event in
                    let mode = event.element!
                    self.canEnterBlockPlaingMode.accept(mode == .move || mode == .place)
                    
                }.disposed(by: self.bag)
            }.disposed(by: self.bag)
            
            
            
            self.canEnterBlockPlaingMode.subscribe{[unowned self] event in
                if !event.element! && self.isPlacingBlockMode.value {
                    self._endBlockEditing(forced: true)
                }
            }.disposed(by: self.bag)
        }
        
    }
}

// ================================================================== //
// MARK: - Extension for TPBlockPlaceHelperDelegate -
extension TPSandBox3DSceneModel: TPBlockEditHelperDelegate {
    func blockEditHelper(placeGuideNodeWith guideNode: SCNNode, at position: TSVector3) {
        binder.__placeNode(guideNode, at: position)
    }
    func blockEditHelper(endBlockPlacingWith guideNode: SCNNode) {
        binder.__removeNode(guideNode)
    }
    func blockEditHelper(moveNodeWith guideNode:SCNNode, to position: TSVector3) {
        binder.__moveNode(guideNode, to: position)
    }
}

// ================================================================== //
// MARK: - Extension for TPCameraGestureHelperDelegate -
extension TPSandBox3DSceneModel: TPCameraGestureHelperDelegate{
    func cameraGestureHelper(_ cameraGestureHelper: TPSandboxCameraGestureHelper, cameraDidMoveTo position: SCNVector3) {
        // ある意味 仮
        manager.didPlayerMoved(to: TSVector3((position - [100, 0, 100])).vector2)
        
        binder.__moveCamera(to: position)
    }
    func cameraGestureHelper(_ cameraGestureHelper: TPSandboxCameraGestureHelper, cameraDidchangeZoomedTo scale: Double) {
        binder.__zoomCamera(to: scale)
    }
}

// ================================================================== //
// MARK: - Extension for TSLevelDelegate -
extension TPSandBox3DSceneModel : TSTerrainEditorDelegate {
    func editor(editorDidDestoroyBlockAt position: TSVector3, needsAnimation: Bool) {
        nodeGenerator.destoryNode(at: position)
        
    }
    
    func editor(editorDidUpdateBlockAt position: TSVector3, needsAnimation animiationFlag: Bool, withRotation rotation: TSBlockRotation) {
        guard let node = nodeGenerator.getNode(atGlobal: position) else {return}
        
        // animation
        if animiationFlag && TSTerrainManager.shared.getAnchorBlock(at: position).shouldAnimateWhenPlaced(at: position) {
            let action = TSBlockAnimator.generateBlockPlaceAnimation(for: node)
            node.runAction(action)
        }
        
        // rotation
        node.eulerAngles = SCNVector3(0, rotation.eulerAngle , 0)
        
        let nodePosition = position + rotation.nodeModifier
        
        binder.__placeNode(node, at: nodePosition)
    }
}
