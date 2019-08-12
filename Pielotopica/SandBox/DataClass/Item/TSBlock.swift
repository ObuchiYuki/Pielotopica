//
//  TSBlock.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/02.
//  Copyright © 2019 yuki. All rights reserved.
//

import SceneKit

/// 最後に指定されたBlockIndexです。
/// Blockが初期化されるたびに更新されます。
private var _lastRegisteredIndex:UInt16 = 1

/**
 SandBoxにおけるオブジェクトを管理するクラスです。
 各オブジェクトに対して生成される`TSBlock` のインスタンスは1つのみとします。
 
 --実装方法--
 
 なんのイベントもないブロックの場合、そのまま`init(nodeNamed:_, textureNamed:_)`を使って初期化し、登録してください。
 イベントを持つブロックの場合、継承しメソッドをオーバーライドしてください。
 */
open class TSBlock {
    // =============================================================== //
    // MARK: - TSBlock Public Properties -
    /// `TSBlock`のidetifierです。
    
    /// 通常はファイル名で初期化されます。
    public let identifier:String
    public let index:UInt16
    
    /// 空気かどうかです。
    public let isAir:Bool
    
    /// Sandbox座標系におけるアイテムのサイズです。
    public lazy var size:TSVector3 = _calculateSize()
    // =============================================================== //
    // MARK: - Private Properties -
    private lazy var _originalNode:SCNNode! = _createNode()
    
    // =============================================================== //
    // MARK: - Methods -
    public func canCreateNode() -> Bool {
        return !isAir
    }
    public func createNode() -> SCNNode {
        assert(self.canCreateNode(), "TP_Air cannot create SCNNode.")
        
        return SCNNode(named: identifier)!
    }
    
    // ============================= //
    // MARK: - TSBlock Overridable Methods -
    
    /// 設置される直前に呼び出されます。
    open func willPlace(at point:TSVector3) {}
    /// 設置後に呼び出されます。
    open func didPlaced(at point:TSVector3) {}
    /// pointに置けるかどうかを返してください。
    open func canPlace(at point:TSVector3) -> Bool {return true}

    /// 破壊される直前に呼び出されます。
    open func willDestroy(at point:TSVector3) {}
    /// 破壊後に呼び出されます。Overrideする時は必ずsuperを呼び出してください。
    open func didDestroy(at point:TSVector3) {
        self.destoryNBData(at: point)
    }
    /// 破壊可能かどうかを返してください。
    open func canDestroy(at point:TSVector3) -> Bool {return true}
    
    /// タッチされた時に呼び出されます。
    open func didTouch(at point:TSVector3) {}
    
    /// タッチ時のアニメーションを行うかを返してください。
    open func shouldAnimateWhenTouched(at point:TSVector3) -> Bool {return false}
    
    /// 設置時のアニメーションをするかを返してください。
    open func shouldAnimateWhenPlaced(at point:TSVector3) -> Bool {return true}
    
    /// 上面にブロックを置けるかを返してください。
    open func canPlaceBlockOnTop(_ block:TSBlock, at point:TSVector3) -> Bool {return false}
    
    /// 周囲のブロックが変更された時に呼び出されます。
    open func didNearBlockUpdate(_ nearBlock:TSBlock, at point:TSVector3) {}
    
    /// 一定のタイミングで呼び出されます。
    open func didRandomEventRoopCome(at point:TSVector3) {}
    
    // =============================================================== //
    // MARK: - Private Methods -
    private func _calculateSize() -> TSVector3 {
        if self.isAir {
            return .unit
        }
        
        let boundingBox = self._originalNode.boundingBox
        var _size = boundingBox.max - boundingBox.min
        
        // ぴったりなら足さない。
        if (_size.x.truncatingRemainder(dividingBy: 1)) >= 0.1 {
            _size.x += 1
        }
        if (_size.y.truncatingRemainder(dividingBy: 1)) >= 0.1 {
            _size.y += 1
        }
        if (_size.z.truncatingRemainder(dividingBy: 1)) >= 0.1 {
            _size.z += 1
        }
        
        return TSVector3(_size)
    }
    
    private func _createNode() -> SCNNode {
        // 空気は実態化できない
        assert(!isAir, "TP_Air have no node to render.")
        
        // ノード生成
        guard let node = SCNNode(named: identifier) else {
            fatalError("No scn file named \"\(identifier).scn\" found.")
        }
        
        return node
    }
    
    //========================================================================
    // MARK: - Constructors -
    init(nodeNamed nodeName:String) {
        self.identifier = nodeName
        self.index = _lastRegisteredIndex
        self.isAir = false
        
        _lastRegisteredIndex += 1
    }
    init() {
        self.identifier = "TP_Air"
        self.index = 0
        self.isAir = true
        
        _lastRegisteredIndex += 1
    }
}

extension TSBlock :Equatable{
    static public func == (left:TSBlock, right:TSBlock) -> Bool {
        return left === right
    }
}
public extension TSBlock {
    static func block(for index:UInt16) -> TSBlock {
        guard let block = TSBlockManager.default.block(for: index) else {
            fatalError("Error in finding TSBlock indexed \(index)")
        }
        return block
    }
    static func block(for idetifier:String) -> TSBlock {
        guard let block = TSBlockManager.default.block(for: idetifier) else {
            fatalError("Error in finding TSBlock idetified \(idetifier)")
        }
        return block
    }
}


extension TSBlock: CustomStringConvertible {
    public var description: String {
        return "TSBlock(named: \"\(identifier)\")"
    }
}
