//
//  TSTerrainManager.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/13.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

// ======================================================================== //
// MARK: - TSTerrainManager -
public class TSTerrainManager {
    
    // MARK: - Properties -
    
    /// Singlton
    public static let shared = TSTerrainManager()

    // ======================================================================== //
    // MARK: - Methods -
    
    /// Playerが動いたら呼び出してください。
    public func playerDidMoved(to point: TSVector2) {
        
        TSChunkLoader.shared.playerDidMove(to: point)
    }
    
    /// チャンクを同期的に取得します。
    /// main スレッドがら呼びださいてください。
    public func getChunkSync(contains point: TSVector2) -> TSChunk {
        let chunkPoint = TSChunk.convertToChunkPoint(fromGlobal: point)
        
        return getChunkSync(at: chunkPoint)
    }
    
    ///　チャンクを非同期的に取得します。
    /// 呼び出しスレッドはどこでも構いません。
    public func getChunkAsync(at point: TSChunkPoint, _ completion: @escaping (TSChunk)->()) {
        DispatchQueue.global(qos: .userInteractive).async {
            let chunk = self.getChunkSync(at: point)
            
            DispatchQueue.main.async {
                completion(chunk)
            }
        }
    }
    
    
    public func _getChunkSync_Asnyc(at point: TSChunkPoint, _ completion: @escaping (TSChunk) -> () ) {
        TSChunkLoader.shared.getLoadedChunkAsunc(at: point) { chunk in
            if let chunk = chunk {
                completion(chunk)
            }
        }
        
        if let saved = TSChunkFileLoader.shared.loadChunkSync(at: point) {  // 保存済み
            return saved
        }
        
        let chunk = TSChunkGenerator.shared.generateChunk(for: point)
        return chunk
    }
    
    ///　チャンクを非同期的に取得します。
    /// main スレッドがら呼びださいてください。
    public func getChunkSync(at point: TSChunkPoint) -> TSChunk {
        if let chunk = TSChunkLoader.shared.getLoadedChunkSync(at: point) {
            return chunk
        }
        
        if let saved = TSChunkFileLoader.shared.loadChunkSync(at: point) {  // 保存済み
            return saved
        }
        
        let chunk = TSChunkGenerator.shared.generateChunk(for: point)
        return chunk
    }
    
    public func getAllAnchors() -> [TSVector3] {
        return TSChunkLoader.shared.getAllLoadedChunks().flatMap{ $0.anchors }
    }
    
    private func chunkPosition(fromGlobal point: TSVector3) -> TSVector3 {
        return TSChunk.convertToChunkPosition(fromGlobal: point)
    }
    
    // ============================================= //
    // MARK: - FillMap Getter and Setter -
    
    // All points below is global points.
    
    public func getFill(at point:TSVector3) -> TSBlock {
        let chunk = self.getChunkSync(contains: point.vector2)
        let (x, y, z) = self.chunkPosition(fromGlobal: point).tuple
        
        return TSBlock.block(for: chunk.fillmap[x][y][z])
    }
    
    public func setFill(_ block:TSBlock, at point:TSVector3) {
        let chunk = self.getChunkSync(contains: point.vector2)
        chunk.isEdited = true
        let (x, y, z) = self.chunkPosition(fromGlobal: point).tuple
        
        chunk.fillmap[x][y][z] = block.index
    }
    
    // MARK: - anchoBlock Getter and Setter -
    public func removeAnchorBlock(_ point: TSVector3) {
        let chunk = self.getChunkSync(contains: point.vector2)
        chunk.isEdited = true
        
        chunk.anchors.remove(point)
    }
    
    public func getAnchorBlock(at point:TSVector3) -> TSBlock {
        let chunk = self.getChunkSync(contains: point.vector2)
        let chunkPos = self.chunkPosition(fromGlobal: point)
        let (x, y, z) = chunkPos.tuple
        
        guard chunk.anchors.contains(chunkPos) else {
            debug("getAnchorBlock(at:) returns Air.")
            
            return .air
        }
        
        return TSBlock.block(for: chunk.fillmap[x][y][z])
    }
    
    public func setAnchorBlock(_ block:TSBlock, at point:TSVector3) {
        let chunk = self.getChunkSync(contains: point.vector2)
        chunk.isEdited = true
        let chunkPosition = self.chunkPosition(fromGlobal: point)
        let (x, y, z) = chunkPosition.tuple
        
        chunk.anchors.insert(chunkPosition)
        chunk.fillmap[x][y][z] = block.index
    }
    
    public func setBlockData(_ data: TSBlockData, at point:TSVector3) {
        let chunk = self.getChunkSync(contains: point.vector2)
        chunk.isEdited = true
        let (x, y, z) = self.chunkPosition(fromGlobal: point).tuple
        
        chunk.datamap[x][y][z] = data.value
    }
    
    public func getBlockData(at point:TSVector3) -> TSBlockData {
        let chunk = self.getChunkSync(contains: point.vector2)
        let (x, y, z) = self.chunkPosition(fromGlobal: point).tuple
        
        return TSBlockData(value: chunk.datamap[x][y][z])
    }
    
    public func getAnchor(ofFill fillPoint: TSVector3) -> TSVector3? {
        let chunk = self.getChunkSync(contains: fillPoint.vector2)
        let (x, y, z) = self.chunkPosition(fromGlobal: fillPoint).tuple
        
        guard chunk.fillmap[x][y][z] != TSBlock.air.index else { return nil }
        
        return chunk.fillAnchors[x][y][z]
    }
    
    public func getFilled(byBlockAt anchorPoint:TSVector3, layerY: Int16) -> [TSVector3] {
        let size = getAnchorBlock(at: anchorPoint).getSize(at: anchorPoint)
        
        var points = [TSVector3]()
        
        for x in OptimazedRange(size.x16) {
            for z in OptimazedRange(size.z16) {
                points.append(anchorPoint + TSVector3(x, layerY, z))
                 
            }
        }
        
        return points
    }
    
    #if DEBUG
    public func enableDebug() {
        for x in -1...1 {
            for z in -1...1 {
                TSE_DebugSprite.show(at: TSVector3(x * 16, 2, z * 16), with: "\(x), \(z)")
            }
        }
    }
    #endif
}
