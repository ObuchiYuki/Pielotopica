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
    // MARK: - Singleton -
    public static let shared = TSChunkNodeGenerator()
    
    // MARK: - Privates -
    /// 生成済みのノードです。
    /// [globalPoint: Node]
    private var nodeMap = [TSVector3: SCNNode]()
    
    // MARK: - Methods -
    public func asycPrepareChunk(_ chunk: TSChunk) {
        
    }
    
    /// 生成済みならそのNodeを未生成なら生成して返します。空気は返さない
    public func getNode(at globalPoint:TSVector3) -> SCNNode? {
        if let loaded = nodeMap[globalPoint] {
            return loaded
        }
        
        let chunk = TSChunkManager.shared.chunk(contains: globalPoint.vector2)
        
    }
}
