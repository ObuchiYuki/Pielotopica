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
        let playerPoint = _calcurateChunkPoint(from: point)
        let loadablePoints = _calcurateLoadablePoints(from: playerPoint)
        
        for loadedChunk in loadedChunks {
            if !loadablePoints.contains(loadedChunk.point) {
                _unloadChunk(loadedChunk)
            }
        }
        
        for loadablePoint in loadablePoints {
            if !loadedChunks.contains(where: {$0.point == loadablePoint}) {
                
                _loadChunk(chunk(at: loadablePoint))
            }
        }
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
    
    private func _loadChunk(_ chunk: TSChunk) {
        loadedChunks.append(chunk)
        
        delegates.forEach{ $0.chunkDidLoad(chunk) }
    }
    private func _unloadChunk(_ chunk: TSChunk) {
        let success = (self.loadedChunks.remove(of: chunk) != nil)
        guard success else { return log.error("Unload chunk failed. \(loadedChunks)") }
        
        
        delegates.forEach{ $0.chunkDidUnload(chunk) }
    }
    
    private func _calcurateLoadablePoints(from point: TSChunkPoint) -> [TSChunkPoint] {
        let distance = TSOptionSaveData.shared.renderDistance
        
        var points = [TSChunkPoint]()
        
        for xd in -distance...distance {
            for zd in -distance...distance {
                points.append(TSChunkPoint(Int16(xd), Int16(zd)))
            }
        }
        
        return points
    }
    private func _calcurateChunkPoint(from pointContaining: TSVector2) -> TSChunkPoint {
        
        return TSChunkPoint(pointContaining.x16 / TSChunk.sideWidth, pointContaining.z16 / TSChunk.sideWidth)
    }    
}
