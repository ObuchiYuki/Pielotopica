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
    static let shared = TSChunkGenerator()
    
    // MARK: - Methods -
    public func generateChunk(for point: TSChunkPoint) -> TSChunk {
        let chunk = TSChunk()
        
        chunk.anchors.insert(.zero)
        for x in 0..<Int(TSChunk.sideWidth) {
            for z in 0..<Int(TSChunk.sideWidth) {
                chunk.fillmap[x][0][z] = TSBlock.ground.index
                chunk.fillAnchors[x][0][z] = .zero
                chunk.datamap[x][0][z] = 0
            }
        }
        
        return chunk
    }
}
