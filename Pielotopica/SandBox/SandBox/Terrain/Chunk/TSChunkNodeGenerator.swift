//
//  TSChunkNodeGenerator.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/14.
//  Copyright © 2019 yuki. All rights reserved.
//

import SceneKit

// MARK: - TSChunkNodeGenerator -

public class TSChunkNodeGenerator {
    
    // ======================================================================== //
    // MARK: - Singleton -
    public static let shared = TSChunkNodeGenerator()
    private init() {}
    
    // ======================================================================== //
    // MARK: - Privates -
    /// 生成済みのノードです。
    /// [globalPoint: Node]
    fileprivate var cache = [TSVector3: SCNNode]()
    
    // ======================================================================== //
    // MARK: - Methods -
    /// 生成済みならそのNodeを未生成なら生成して返します。空気は返さない
    public func getNode(atGlobal point:TSVector3) -> SCNNode? {
        if let loaded = cache[point] {
            return loaded
        }
        
        let block = TSTerrainManager.shared.getAnchorBlock(at: point)
        
        guard let node = _createNode(of: block, at: point) else { return nil }
        
        _cacheNode(node, at: point)
        
        return node
    }
    
    public func destoryNode(at anchorPoint:TSVector3) {
        guard let node = self.cache.removeValue(forKey: anchorPoint) else { return }
            
        node.removeFromParentNode()
    }
    
    // ======================================================================== //
    // MARK: - Private -
    
    private func _createNode(of block: TSBlock, at point: TSVector3) -> SCNNode? {
        guard block.canCreateNode() else { return nil }
        
        let node = block.createNode()
        
        return node
    }
    
    private func _cacheNode(_ node: SCNNode, at point: TSVector3) {
        self.cache[point] = node
    }
}

extension TSBlock {
    /// もし自身が生成済みなら返します。
    func getOwnNode(at point: TSVector3) -> SCNNode? {
        return TSChunkNodeGenerator.shared.cache[point]
    }
}
