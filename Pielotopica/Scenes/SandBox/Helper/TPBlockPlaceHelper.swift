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
    private var nodePosition = TSVector3()
    
    // =============================================================== //
    // MARK: - Methods -
    
    /// HitTestが終わったら、hitTestのworldCoodinateで呼びだしてください。
    func startBlockPlacing(from position:TSVector3) {
        guard let blockNode = blockNode else { return }
        guard level.canPlace(block, at: position), let initialPosition = level.calculatePlacablePosition(for: block, at: position.vector2) else {
            self._calculatePlacablePositionFailture(at: position)
            return
        }
        
        self.initialNodePosition = initialPosition
        nodePosition = position
        delegate?.blockPlaceHelper(placeGuideNodeWith: blockNode, at: initialPosition)
    }
    
    /// ドラッグが開始されたら呼び出してください。
    func onTouch() {
        blockNode.map{TSVector3($0.position)}.map{initialNodePosition = $0}
        
        timeStamp.press()
    }
    
    /// 画面がドラッグされたら呼びだしてください。
    func blockDidDrag(with vector:CGPoint) {
        guard timeStamp.isSameFrame() else { return }
        timeStamp.press()
        
        guard let blockNode = blockNode else {return}
        
        nodePosition = initialNodePosition + _convertToNodeMovement(from: TSVector2(vector)) // ノードの場所計算
        delegate?.blockPlaceHelper(moveNodeWith: blockNode, to: nodePosition) /// 通知
        
        // 置けるかどうかでマテリアル指定
        if !level.canPlace(block, at: nodePosition) {
            blockNode.material?.selfIllumination.contents = UIColor.red
        } else {
            blockNode.material?.selfIllumination.contents = UIColor.black
        }
    }

    /// 現在の場所にブロックを設置できるかを返します。
    func canEndBlockPlacing() -> Bool {
        return level.canPlace(block, at: nodePosition)
    }
    
    /// 編集モード完了時に呼びだしてください。最終的に決定した場所を返します。
    /// 確定する前にcanEndBlockPlacing()を呼んでください。
    func endBlockPlacing() {
        isPlacingEnd = true
        guard let blockNode = blockNode else {fatalError()}
        
        delegate?.blockPlacehelper(endBlockPlacingWith: blockNode)
    }
    
    func getFinalBlockPosition() -> TSVector3 {
        assert(isPlacingEnd, "Block placing is not ended.")
        
        guard let blockNode = blockNode else {fatalError()}
        
        return TSVector3(blockNode.position)
    }
    
    // =============================================================== //
    // MARK: - Constructor -
    
    init(delegate:TPBlockPlaceHelperDelegate, block:TSBlock) {
        self.delegate = delegate
        self.block = block
    }
    
    // =============================================================== //
    // MARK: - Private Methods -
    
    private func _convertToNodeMovement(from vector2:TSVector2) -> TSVector3 {
        
        let transform = CGAffineTransform(rotationAngle: -.pi/4).scaledBy(x: 0.05, y: 0.05)
        let transformed = vector2.applying(transform)
        
        if abs(transformed.x16) > abs(transformed.z16) {
           return [transformed.x16, 0, 0]
        } else {
            return [0, 0, transformed.z16]
        }
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
