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
    private var nodeMap = [TSVector3: SCNNode]()
    
    public func asycPrepareChunk(_ chunk: TSChunk) {
        
    }
    
}
