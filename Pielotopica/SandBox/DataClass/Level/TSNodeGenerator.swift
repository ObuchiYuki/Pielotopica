//
//  TSNodeGenerator.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/16.
//  Copyright © 2019 yuki. All rights reserved.
//

import SceneKit

private let kArrayAccessMargin = 1000

// =============================================================== //
// MARK: - TSNodeGenerator -

/**
 */
public class TSNodeGenerator {
    // =============================================================== //
    // MARK: - Properties -
    
    /// 管理しているレベルです。
    public let level:TSLevel
    
    // =============================================================== //
    // MARK: - Private Properties -
    
    /// 生成済みのノードです。
    /// 直接編集せず _generateNode(_:, _:) _getNode(_:) を使用してください。
    private var allNodes:[[[SCNNode?]]] =
        Array(repeating: Array(repeating: Array(repeating: nil, count: kLevelMaxZ), count: kLevelMaxY), count: kLevelMaxX)
    
    
    // =============================================================== //
    // MARK: - Methods -
    
    /// アンカーポイントにブロックがあれば、ブロックのSCNNodeを返します。
    /// なければ、新規に作成してノード作成してノードを返します。
    public func getNode(for anchorPoint:TSVector3) -> SCNNode? {
        
        let block = level.getAnchorBlock(at: anchorPoint)
        
        if let node = _getNode(at: anchorPoint) { // 生成済みならば
            return node
        }
        
        if block.canCreateNode() { // 未生成ならば
            
            let node = block.createNode()
            self._setNode(node, at: anchorPoint)
            
            return node
        }
        
        return nil
    }
    
    // =============================================================== //
    // MARK: - Constructor -
    
    public init(level:TSLevel) {
        self.level = level
        level.nodeGenerator = self
    }
    
    // =============================================================== //
    // MARK: - Private Methods -
    
    
    // MARK: - NodeMap Getter and Setter -
    private func _setNode(_ node:SCNNode, at point:TSVector3){
        let (x, y, z) = _convertVector3(point)
        
        allNodes[x][y][z] = node
    }
    
    private func _getNode(at point:TSVector3) -> SCNNode? {
        let (x, y, z) = _convertVector3(point)
        
        return allNodes[x][y][z]
    }
    
    /// TSVector3を配列アクセス用のIndexに変換します。
    public func _convertVector3(_ vector3:TSVector3) -> (Int, Int, Int) {
        
        return (vector3.x + kArrayAccessMargin, vector3.y, vector3.z + kArrayAccessMargin)
    }
}

public extension TSBlock {
    /// 自身のノードが生成済みなら、そのノードを
    /// 未生成なら新規ノードを返します。
    func getOwnNode(at point:TSVector3) -> SCNNode? {
        return TSLevel.current().nodeGenerator?.getNode(for: point)
    }
}
