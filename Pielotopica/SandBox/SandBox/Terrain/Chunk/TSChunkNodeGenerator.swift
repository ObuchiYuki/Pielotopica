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
    private var cache = [TSVector3: SCNNode]()
    
    // ======================================================================== //
    // MARK: - Methods -
    public func asycPrepareChunk(_ chunk: TSChunk) {
        
    }
    
    /// 生成済みならそのNodeを未生成なら生成して返します。空気は返さない
    public func getNode(atGlobal point:TSVector3) -> SCNNode? {
        if let loaded = cache[point] {
            return loaded
        }
        
        let block = TSChunkManager.shared.getAnchorBlock(at: point)
        
        guard block.canCreateNode() else { return nil }
        
        let node = block.createNode()
        
        return node
    }
    
    public func destoryNode(at anchorPoint:TSVector3) {
        let node = nodeMap.removeValue(forKey: anchorPoint)
        node?.removeFromParentNode()
    }
    
    // ======================================================================== //
    // MARK: - Private -
    private func _cacheNode(_ node: SCNNode, at point: TSVector3) {
        cache[point] = node
    }
}
