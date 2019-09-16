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
    
    // ======================================================================== //
    // MARK: - Privates -
    /// 生成済みのノードです。
    /// [globalPoint: Node]
    fileprivate var cache = [TSVector3: SCNNode]()
    
    // ======================================================================== //
    // MARK: - Methods -
    public func asycPrepareChunk(_ chunk: TSChunk) {
        DispatchQueue.global().async {
            for anchor in chunk.anchors {
                let (x, y, z) = anchor.tuple
                
                let block = TSBlock.block(for: chunk.fillmap[x][y][z])
                
                self.cache[anchor] = self._createNode(of: block, at: anchor)
            }
        }
    }
    /// 生成済みならそのNodeを未生成なら生成して返します。空気は返さない
    public func getNode(atGlobal point:TSVector3) -> SCNNode? {
        if let loaded = cache[point] {
            return loaded
        }
        
        let block = TSTerrainManager.shared.getAnchorBlock(at: point)
        
        return _createNode(of: block, at: point)
    }
    
    public func destoryNode(at anchorPoint:TSVector3) {
        let node = cache.removeValue(forKey: anchorPoint)
        
        if node == nil { log.error("Try to remove uncached node. \(cache)") }
        
        node?.removeFromParentNode()
    }
    
    // ======================================================================== //
    // MARK: - Private -
    
    private func _createNode(of block: TSBlock, at point: TSVector3) -> SCNNode? {
        guard block.canCreateNode() else { return nil }
        
        let node = block.createNode()
        
        _cacheNode(node, at: point)
        
        return node
    }
    
    private func _cacheNode(_ node: SCNNode, at point: TSVector3) {
        cache[point] = node
    }
}

extension TSBlock {
    /// もし自身が生成済みなら返します。
    func getOwnNode(at point: TSVector3) -> SCNNode? {
        return TSChunkNodeGenerator.shared.cache[point]
    }
}
