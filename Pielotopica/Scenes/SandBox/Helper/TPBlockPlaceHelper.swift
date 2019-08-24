//
//  TSBlockPlaceHelper.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/16.
//  Copyright © 2019 yuki. All rights reserved.
//

import RxCocoa
import RxSwift
import SceneKit

// =============================================================== //
// MARK: - TPBlockPlaceHelperDelegate -

/**
 TSBlockPlaceHelperのDelegateです。

 */
public protocol TPBlockPlaceHelperDelegate :class{
    var nodeGenerator:TSNodeGenerator { get }
    
    /// ガイドノードを設置してください。
    func blockPlaceHelper(placeGuideNodeWith node:SCNNode, at position:TSVector3)
    /// ブロック設置の終了処理をしてください。
    func blockPlacehelper(endBlockPlacingWith node:SCNNode)
    /// ガイドノードを移動させてください。
    func blockPlaceHelper(moveNodeWith node:SCNNode, to position:TSVector3)
    
    /// ブロック設置を失敗した時の処理をしてください。
    func blockPlaceHelper(failToFindInitialBlockPointWith node:SCNNode, to position:TSVector3)
}

// =============================================================== //
// MARK: - TSBlockPlaceHelper -

/**
 ブロック設置の補助をします。
 ジェスチャー・置かれたかどうかなど。
 
 -- Usage --
 
 // Init
 let helper = TSBlockPlaceHelper(delegate: Delegate, block: Block)
 
 // hitTest後
 helper.startBlockPlacing(from: hitTestPoint)
 
 // タッチ開始時
 helper.onTouch()
 
 // PanGestureRecognizerによる呼び出し。
 helper.blockDidDrag(with: panVector)
 
 // 置く場所決定時
 
 if helper.canEndBlockPlacing() {
    helper.endBlockPlacing()
 
    placeBlock(at: helper.getFinalBlockPosition())
 }

 
 */
class TSBlockPlaceHelper {
    // =============================================================== //
    // MARK: - Properties -    public let targetBlock:TSBlock
    
    public weak var delegate:TPBlockPlaceHelperDelegate?
    /// 管理するブロックです。
    public let block:TSBlock
    
    // =============================================================== //
    // MARK: - Private Properties -
    
    // - Managing -
    /// 管理するレベルです。
    private let level = TSLevel.grobal
    
    private var isPlacingEnd = false
    
    private var timeStamp = RMTimeStamp()
    
    /// ブロック仮設置用ノードです。
    private lazy var blockNode:SCNNode? = {
        guard block.canCreateNode() else {return nil}
        
        let node = block.createNode()
        node.material?.transparencyMode = .singleLayer
        node.material?.transparency = 0.5
        
        return node
    }()
    
    // - Variables -
    
    private var dragStartingPosition = TSVector2()
    
    private var initialNodePosition = TSVector3()
        
    #if DEBUG
    private var _debugAnchorNode:SCNNode = {
        let _debugAnchorNode = SCNNode()
        _debugAnchorNode.isHidden = true
        let box = SCNBox(width: 0.8, height: 0.8, length: 0.8, chamferRadius: 0.1)
        box.firstMaterial?.diffuse.contents = UIColor.red
        _debugAnchorNode.geometry = box
        TPSandboxSceneController._debug.scene.rootNode.addChildNode(_debugAnchorNode)
        return _debugAnchorNode
    }()
    #endif
    
    private var nodePosition = TSVector3() {
        didSet{
            _debugAnchorNode.position = nodePosition.scnVector3 + [0.5, 0.5, 0.5]
        }
    }
    
    // =============================================================== //
    // MARK: - Methods -
    private var _blockRotation = 0
    /// 現在のブロックを回転させます。
    func rotateCurrentBlock() {
        let rotateAction = _createNodeRotationAnimation(
            blockSize: block.getSize(at: nodePosition),
            rotation: _blockRotation
        )
        let movement = _anchorPointMovement(
            blockSize: block.getSize(at: nodePosition),
            for: _blockRotation
        )
        nodePosition = nodePosition + movement
        
        blockNode?.runAction(rotateAction)
        
        _blockRotation += 1
    }
    
    /// HitTestが終わったら、hitTestのworldCoodinateで呼びだしてください。
    func startBlockPlacing(from position:TSVector3) {
        #if DEBUG
        _debugAnchorNode.isHidden = false
        #endif
        guard let blockNode = blockNode else { return }
        guard
            level.canPlace(block, at: position, atRotation: TSBlockRotation(rotation: _blockRotation)),
            let initialPosition = level.calculatePlacablePosition(for: block, at: position.vector2)
        else {
            self._calculatePlacablePositionFailture(at: position)
            return
        }
        
        self.initialNodePosition = initialPosition
        nodePosition = position
        delegate?.blockPlaceHelper(placeGuideNodeWith: blockNode, at: initialPosition)
    }
    
    /// ドラッグが開始されたら呼び出してください。
    func onTouch() {
        initialNodePosition = nodePosition
        
        timeStamp.press()
    }
    
    /// 画面がドラッグされたら呼びだしてください。
    func blockDidDrag(with vector:CGPoint) {
        guard timeStamp.isSameFrame() else { return }
        timeStamp.press()
        
        guard let blockNode = blockNode else {return}
        
        nodePosition = initialNodePosition + _convertToNodeMovement(fromTouchVector: TSVector2(vector)) // ノードの場所計算
        delegate?.blockPlaceHelper(moveNodeWith: blockNode, to: nodePosition) /// 通知
        
        // 置けるかどうかでマテリアル指定
        if !level.canPlace(block, at: nodePosition, atRotation: .x0) {
            blockNode.material?.selfIllumination.contents = UIColor.red
        } else {
            blockNode.material?.selfIllumination.contents = UIColor.black
        }
    }

    /// 現在の場所にブロックを設置できるかを返します。
    func canEndBlockPlacing() -> Bool {
        return level.canPlace(block, at: nodePosition, atRotation: TSBlockRotation(rotation: _blockRotation))
    }
    
    /// 編集モード完了時に呼びだしてください。最終的に決定した場所を返します。
    /// 確定する前にcanEndBlockPlacing()を呼んでください。
    func endBlockPlacing() {
        #if DEBUG
        _debugAnchorNode.isHidden = true
        #endif
        isPlacingEnd = true
        guard let blockNode = blockNode else {fatalError()}

        self.level.placeBlock(block, at: nodePosition, rotation: TSBlockRotation(rotation: _blockRotation))
        
        delegate?.blockPlacehelper(endBlockPlacingWith: blockNode)
        
        GKSoundPlayer.shared.playSoundEffect(.place)
    }
    
    
    // =============================================================== //
    // MARK: - Constructor -
    
    init(delegate:TPBlockPlaceHelperDelegate, block:TSBlock) {
        self.delegate = delegate
        self.block = block
    }
    
    // =============================================================== //
    // MARK: - Private Methods -
    
    private func _anchorPointMovement(blockSize: TSVector3, for rotation:Int) -> TSVector3 {
        let v1 = _rotateVector(SCNVector3(Double(blockSize.x) / 2 - 0.5, 0, Double(blockSize.z) / 2 - 0.5), rotation: rotation)
            
        let (x, z) = (v1.x, v1.z)
        let (X, Z) = (z, -x)
        let (dx, dz) = (x - X, z - Z)
        
        return TSVector3(Int16(dx), 0, Int16(dz))
    }
    
    /// 中心（奇数の場合は自動調整）周りに rotation x 90度 反時計回り
    private func _createNodeRotationAnimation(blockSize: TSVector3, rotation ry: Int) -> SCNAction {
        let v1 = _rotateVector(SCNVector3(Double(blockSize.x) / 2, 0, Double(blockSize.z) / 2), rotation: ry)
            
        let (x, z) = (v1.x, v1.z)
        let (X, Z) = (z, -x)
        let (dx, dz) = (x - X, z - Z)
        
        let a1 = SCNAction.move(by: SCNVector3(dx, 0, dz), duration: 0.1)
        let a2 = SCNAction.rotateBy(x: 0, y: .pi/2, z: 0, duration: 0.1)
        
        return SCNAction.group([a1, a2]).setEase(.easeInEaseOut)
    }
    
    private func _rotateVector(_ vector:SCNVector3, rotation ry:Int) -> SCNVector3 {
        switch ry % 4 {
        case 0: return vector
        case 1: return SCNVector3( vector.z,  vector.y, -vector.x)
        case 2: return SCNVector3(-vector.x,  vector.y, -vector.z)
        case 3: return SCNVector3(-vector.z,  vector.y,  vector.x)
        default: fatalError()
        }
    }
        
    private func _convertToNodeMovement(fromTouchVector vector2:TSVector2) -> TSVector3 {
        /// ピンチ率に合わせて変更
        let tscale = 1.0 / TPSandboxCameraGestureHelper.initirized!.getPinchScale() * 0.03
        
        let transform = CGAffineTransform(rotationAngle: -.pi/4).scaledBy(x: CGFloat(tscale), y: CGFloat(tscale))
        let transformed = vector2.applying(transform)
        
        return [transformed.x16, 0, transformed.z16]
    }
    
    private func _calculatePlacablePositionFailture(at position:TSVector3) {
        guard let showFailtureNode = blockNode else {return}
        
        delegate?.blockPlaceHelper(failToFindInitialBlockPointWith: showFailtureNode, to: position)
        
        showFailtureNode.runAction(_failtureAction())
    }
    
    private func _failtureAction() -> SCNAction {
        let redIlluminationAction = SCNAction.run{node in
            node.material?.selfIllumination.contents = UIColor.red
        }
        
        let normaIlluminationAction = SCNAction.run{node in
            node.material?.selfIllumination.contents = UIColor.black
        }
        
        let waitAction = SCNAction.wait(duration: 0.1)
        
        let sequestceAction = SCNAction.sequence([redIlluminationAction,waitAction, normaIlluminationAction, waitAction])
        let repeatAction = SCNAction.repeat(sequestceAction, count: 2)
        
        let removeAction = SCNAction.run{ $0.removeFromParentNode() }
        
        let resultAction = SCNAction.sequence([repeatAction, removeAction])
        
        return resultAction
    }
}
