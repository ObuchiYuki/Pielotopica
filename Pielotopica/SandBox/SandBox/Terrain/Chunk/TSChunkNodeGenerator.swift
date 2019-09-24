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
    
    public static let chunkPrepareQueue = DispatchQueue(label: "com.topica.chunkPrepareQueue")
    
    // ======================================================================== //
    // MARK: - Singleton -
    public static let shared = TSChunkNodeGenerator()
    private init() {}
    
    // ======================================================================== //
    // MARK: - Privates -
    /// 生成済みのノードです。
    /// [globalPoint: Node]
    fileprivate var cache = [TSVector3: SCNNode]()
    
    private var preparingChunk = Set<TSChunk>()
    
    // ======================================================================== //
    // MARK: - Methods -
    
    public func isFreeChunk(at chunkPoint: TSChunkPoint) -> Bool {
        return preparingChunk.allSatisfy({ $0.point != chunkPoint })
    }
    
    public func prepareAsync(for chunk: TSChunk, _ completion: @escaping ()->() ) {
        
        DispatchQueue.main.async {
            self.preparingChunk.insert(chunk)
        }
        
        DispatchQueue.global().async {

            for anchor in chunk.anchors {
                let block = chunk.getFillBlock(at: anchor)
                    
                _ = self._createNode(of: block, at: chunk.makeGlobal(anchor))
            }
            
            DispatchQueue.main.async {
                self.preparingChunk.remove(chunk)
                
                completion()
            }
        }
    }
    
    public func anchor(of node: SCNNode) -> TSVector3 {
        guard let vector = cache.first(where: {vector, _node in _node == node})?.0 else {
            guard let vector = cache.first(where: {vector, _node in _node == node.parent})?.0 else {
                fatalError()
            }
            
            return vector
        }
        
        return vector
    }
    
    /// 生成済みならそのNodeを未生成なら生成して返します。空気は返さない
    public func getNode(atGlobal point:TSVector3) -> SCNNode? {
        if let loaded = cache[point] {
            return loaded
        }
        let block = TSTerrainManager.shared.getAnchorBlock(at: point)
        
        guard let node = _createNode(of: block, at: point) else { return nil }
                
        return node
    }
    
    public func destoryNode(at anchorPoint:TSVector3) {
        DispatchQueue.main.async {

            guard let node = self.cache.removeValue(forKey: anchorPoint) else {
                return debug("This node already removed.")
            }
                
            node.removeFromParentNode()
        }
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
        
        DispatchQueue.main.async {
            if let beforeNode = self.cache[point] {
                log.debug("Why don't you destroy node before create new one at \(point).")
                beforeNode.removeFromParentNode()
            }
            
            self.cache[point] = node
        }
    }
}

extension TSBlock {
    /// もし自身が生成済みなら返します。
    func getOwnNode(at point: TSVector3) -> SCNNode? {
        return TSChunkNodeGenerator.shared.cache[point]
    }
}
