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
 
 （`point`とはAnchorPointのことです。）
 */
open class TSBlock {
    // =============================================================== //
    // MARK: - TSBlock Public Properties -
    /// `TSBlock`のidetifierです。
    /// 通常はファイル名で初期化されます。
    public let identifier:String
    public let index:UInt16
    
    /// 空気かどうかです。
    private(set) lazy var isAir:Bool = index == 0
    
    /// Sandbox座標系におけるアイテムのサイズです。 アンカーポイントからのベクターで表されます。
    /// マイナスの数を取ることもあります。
    public func getSize(at point:TSVector3, at rotation:TSBlockRotation? = nil) -> TSVector3 {
        if let rotation = rotation {
            
            return _rotatedNodeSize(at: point, at: rotation)
        }else if let data = getBlockData(at: point){
            
            return _rotatedNodeSize(at: point, at: TSBlockRotation(data: data))
        }else {
            
            return getOriginalNodeSize()
        }
        
    }
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
    
    open func getOriginalNodeSize() -> TSVector3 {
        fatalError("\(type(of: self))")
    }
    /// 設置される直前に呼び出されます。
    open func willPlace(at point:TSVector3) {}
    /// 設置後に呼び出されます。
    open func didPlaced(at point:TSVector3) {}
    /// pointに置けるかどうかを返してください。
    open func canPlace(at point:TSVector3) -> Bool {return true}
    
    /// 破壊される直前に呼び出されます。
    open func willDestroy(at point:TSVector3) {}
    /// 破壊後に呼び出されます。Overrideする時は必ずsuperを呼び出してください。
    open func didDestroy(at point:TSVector3) {}
    /// 破壊可能かどうかを返してください。
    open func canDestroy(at point:TSVector3) -> Bool {return false}
    
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
    
    private func _rotatedNodeSize(at point:TSVector3, at rotation:TSBlockRotation) -> TSVector3 {
        let _size = getOriginalNodeSize()
        
        switch rotation {
        case .x0: return _size
        case .x1: return TSVector3( _size.z16, _size.y16, -_size.x16)
        case .x2: return TSVector3(-_size.x16, _size.y16, -_size.z16)
        case .x3: return TSVector3(-_size.z16, _size.y16,  _size.x16)
        }
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
    init(nodeNamed nodeName:String, index:Int) {
        self.identifier = nodeName
        self.index = UInt16(index)
        
        assert(!TSBlock._registerdBlock.contains(self), "The Block indexed \(index) already exists. Try use other index")
        
        TSBlock._registerdBlock.append(self)
    }
    init() {
        self.identifier = "TP_Air"
        self.index = 0
        
        TSBlock._registerdBlock.append(self)
    }
}

extension TSBlock {
    /// 作成済みのBlock一覧です。
    private static var _registerdBlock = [TSBlock]()
    
}

extension TSBlock :Equatable{
    static public func == (left:TSBlock, right:TSBlock) -> Bool {
        return left.index == right.index
    }
}
public extension TSBlock {
    static func block(for index:UInt16) -> TSBlock {
        guard let block = _registerdBlock.first(where: {$0.index == index}) else {
            fatalError("Error in finding TSBlock indexed \(index)")
        }
        
        return block
    }
    static func block(for identifier:String) -> TSBlock {
        guard let block = _registerdBlock.first(where: {$0.identifier == identifier}) else {
            fatalError("Error in finding TSBlock with identifier: \(identifier)")
        }
        return block
    }
}


extension TSBlock: CustomStringConvertible {
    public var description: String {
        return "TSBlock(named: \"\(identifier)\")"
    }
}
