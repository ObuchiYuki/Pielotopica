//
//  TPBlockEditHelper.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/24.
//  Copyright © 2019 yuki. All rights reserved.
//

import SceneKit

public protocol TPBlockEditHelperDelegate: class{
    /// ガイドノードを設置してください。
    func blockEditHelper(placeGuideNodeWith node: SCNNode, at position: TSVector3)
    
    /// ブロック設置の終了処理をしてください。
    func blockEditHelper(endBlockPlacingWith node: SCNNode)
    
    /// ガイドノードを移動させてください。
    func blockEditHelper(moveNodeWith node:SCNNode, to position: TSVector3)
}

public class TPBlockEditHelper {
    // =============================================================== //
    // MARK: - Properties -
    
    /// TSTerrainEditor
    public let editor = TSTerrainEditor.shared
    
    /// delegate of BlockEditHelper
    public weak var delegate:TPBlockEditHelperDelegate!
    
    /// 管理するブロックです。
    public let block:TSBlock
    
    /// ブロック仮設置用ノードです。
    public lazy var guideNode:SCNNode = _createGuideNode(from: self.block)
    
    // =============================================================== //
    // MARK: - Private Properties -
    
    // Editが終わったかどうか（この時点でこのHelperはもう使われない）
    private var isEdtingEnd = false
    
    // Gesture
    private var _dragCheckTimeStamp = RMTimeStamp()
    private var _dragStartingPosition = TSVector2()
    private var _initialNodePosition = TSVector3()
    
    // manager
    internal var _nodePosition = TSVector3() { didSet{ _checkBlockPlaceability() } }
    
    // 現在の回転状況
    private var _blockRotation = 0
    
    // Accessers
    internal var _roataion:TSBlockRotation {
        return TSBlockRotation(rotation: _blockRotation)
    }
    
    // =============================================================== //
    // MARK: - Methods -
    
    //MARK: - Block Edting -
    
    /// 編集を始めます。
    func startEditing(from anchorPoint: TSVector3, startRotation rotation: Int) {
        let tsrotation = TSBlockRotation(rotation: rotation)
        
        self._initialNodePosition = anchorPoint
        self._nodePosition = anchorPoint
        self._blockRotation = rotation
        
        guideNode.eulerAngles = SCNVector3(0, Double(rotation) * .pi/2, 0)
        
        delegate.blockEditHelper(placeGuideNodeWith: guideNode, at: anchorPoint + tsrotation.nodeModifier)
    }
    
    /// ブロックを回転させます。
    func rotateBlock() {
        let rotateAction = TSModelRotator.shared.createNodeRotationAnimation(
            blockSize: block.getSize(at: _nodePosition),
            rotation: _blockRotation
        )
        
        let movement = TSModelRotator.shared.calcurateAnchorPointDeltaMovement(
            blockSize: block.getSize(at: _nodePosition),
            for: _blockRotation
        )
        
        _nodePosition = _nodePosition + movement
        
        guideNode.runAction(rotateAction)
        
        _blockRotation += 1
    }
    
    // MARK: - Gesture -
    
    /// タッチ開始時に呼び出してください。
    func onTouchBegan() {
        _initialNodePosition = _nodePosition
        
        _dragCheckTimeStamp.press()
    }
    
    /// ドラッグで呼び出してください。
    func onDrag(at vector:CGPoint) {
        guard _dragCheckTimeStamp.isSameFrame() else { return }
        _dragCheckTimeStamp.press()
        
        _nodePosition = _initialNodePosition + _convertToNodeMovement(fromTouchVector: TSVector2(vector)) // ノードの場所計算
        delegate.blockEditHelper(moveNodeWith: guideNode, to: _nodePosition + _roataion.nodeModifier) /// 通知
        
    }

    /// 現在の場所にブロックを設置できるかを返します。
    public func canEndBlockEditing() -> Bool {
        return editor.canPlaceBlock(block, at: _nodePosition, rotation: _roataion)
    }
    
    /// 編集モード完了時に呼びだしてください。
    /// canEndBlockPlacing()でない場所で呼び出した場合は動作を取り消します。
    public func endBlockEditing() {
        
        isEdtingEnd = true

        delegate.blockEditHelper(endBlockPlacingWith: guideNode)
        
        _placeBlock()
    }
    
    internal func _placeBlock() {
        if canEndBlockEditing() {
            editor.placeBlock(block, at: _nodePosition, rotation: _roataion)
        }
    }
    
    // =============================================================== //
    // MARK: - Constructor -
    
    init(delegate:TPBlockEditHelperDelegate, block:TSBlock) {
        self.delegate = delegate
        self.block = block
    }
    
    // =============================================================== //
    // MARK: - Private Methods -
    
    // MARK: - gesture -
    private func _convertToNodeMovement(fromTouchVector vector2:TSVector2) -> TSVector3 {
        /// ピンチ率に合わせて変更
        let tscale = 1.0 / TPSandboxCameraGestureHelper.initirized!.getPinchScale() * 0.03
        
        let transform = CGAffineTransform(rotationAngle: -.pi/4).scaledBy(x: CGFloat(tscale), y: CGFloat(tscale * 1.3))
        let transformed = vector2.applying(transform)
        
        return [transformed.x16, 0, transformed.z16]
    }
    
    /// ガイドノード作成
    private func _createGuideNode(from block:TSBlock) -> SCNNode {
        guard block.canCreateNode() else {fatalError("You! you now did try to place air!! How was it possible!")}
        
        let containerNode = SCNNode()
        
        let node = block.createNode()
        node.fmaterial?.transparencyMode = .singleLayer
        node.fmaterial?.transparency = 0.5
        containerNode.addChildNode(node)
        
        let nodeSize = block.getOriginalNodeSize()
        
        for x in 0..<nodeSize.x {
            for z in 0..<nodeSize.z {
                
                let gnode = SCNNode()
                gnode.name = "gnode"
                gnode.geometry = SCNBox(width: 0.8, height: 0.1, length: 0.8, chamferRadius: 0)
                gnode.geometry?.firstMaterial?.diffuse.contents = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
                gnode.position = SCNVector3(Double(x) + 0.5, 0, Double(z) + 0.5)
                
                containerNode.addChildNode(gnode)
            }
        }
        
        return containerNode
    }
    
    /// ガイドノード複雑だからね...
    private func getMaterial(from guideNode:SCNNode) -> SCNMaterial {
        return guideNode.childNode(withName: "_palette", recursively: true)!.geometry!.firstMaterial!
    }
    
    /// ブロックが置けるかどうかを判定しマテリアへんけ
    private func _checkBlockPlaceability() {
        
        // 置けるかどうかでマテリアル指定
        if canEndBlockEditing() {
            getMaterial(from: guideNode).selfIllumination.contents = UIColor.black
        } else {
            getMaterial(from: guideNode).selfIllumination.contents = UIColor.red
        }
    }
}
