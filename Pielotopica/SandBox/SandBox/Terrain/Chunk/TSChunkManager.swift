//
//  TSChunkLoader.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/18.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

// ======================================================================== //
// MARK: - TSChunkManagerDelegate -
public protocol TSChunkManagerDelegate {
    func chunkDidLoad(_ chunk: TSChunk)
    func chunkDidUnload(_ chunk: TSChunk)
}

class TSChunkLoader {
    static let shared = TSChunkManager()
    

    public var delegates = RMWeakSet<TSTerrainManagerDelegate>()
    
    var playerPosition = TSVector2.zero
    
    var loadedChunks = Set<TSChunk>()
    
}
