//
//  TSChunkGenerator.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/13.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

// MARK: - TSTerrainGenerator -
public class TSChunkGenerator {
    // MARK: - Singleton -
    static let shared = TSTerrainGenerator()
    
    // MARK: - Methods -
    public func generateChunk(for point: TSChunkPoint) -> TSChunk {
        let chunk = TSChunk()
        
        return chunk
    }
}
