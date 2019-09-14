//
//  TSChunkManager.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/13.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

public protocol TSChunkManagerDelegate {
    func chunkDidLoad(_ chunk: TSChunk)
    func chunkDidUnload(_ chunk: TSChunk)
}


public class TSChunkManager {
    
    public static let shared = TSChunkManager()

    // MARK: - Properties -
    public var delegates = RMWeakSet<TSChunkManagerDelegate>()
    
    private var loadedChunks = [TSChunk]()
    
    // MARK: - Methods -
    
    public func didPlayerMoved(to point: TSVector2) {
        let chunkPoint = _calcurateChunkPoint(from: point)
        
    }
    
    public func chunk(contains point: TSVector2) -> TSChunk {
        let chunkPoint = _calcurateChunkPoint(from: point)
        
        return chunk(at: chunkPoint)
    }
    
    public func chunk(at point: TSChunkPoint) -> TSChunk {
        if let saved = TSChunkFileLoader.shared.loadChunk(at: point) {
            return saved
        }else{
            return TSTerrainGenerator.shared.generateChunk(for: point)
        }
    }
    
    // MARK: - Privates -
    
    private func _loadChunk(at point: TSChunkPoint) {
        fatalError()
    }
    private func _unloadChunk(at point: TSChunkPoint) {
        fatalError()
    }
    
    private func _calcurateLoadablePoints(from point: TSChunkPoint) -> [TSChunkPoint] {
        let distance = TSOptionSaveData.shared.renderDistance
        
        var points = [TSChunkPoint]()
        
        for xd in -distance...distance {
            for xd in -distance...distance {
                points.append(TSChunkPoint(Int16(xd), Int16(xd)))
            }
        }
        
        return points
    }
    private func _calcurateChunkPoint(from pointContaining: TSVector2) -> TSChunkPoint {
        
        return TSChunkPoint(pointContaining.x16 / TSChunk.sideWidth, pointContaining.z16 / TSChunk.sideWidth)
    }    
}
