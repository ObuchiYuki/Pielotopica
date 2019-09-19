//
//  TSChunkLoader.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/18.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

// ======================================================================== //
// MARK: - TSChunkLoaderDelegate -
public protocol TSChunkLoaderDelegate {
    func chunkDidLoad(_ chunk: TSChunk)
    func chunkDidUnload(_ chunk: TSChunk)
}

class TSChunkLoader {
    // ======================================================================== //
    // MARK: - Properties -
    
    static let shared = TSChunkLoader()
    
    public var delegates = RMWeakSet<TSChunkLoaderDelegate>()
    
    // MARK: - Privates -
    private var loadedChunks = Set<TSChunk>()
    private var unloadedChunks = Set<TSChunk>()
    
    private var playerPosition = TSVector2.zero
    
    // ======================================================================== //
    // MARK: - Methods -
    
    public func getAllLoadedChunks() -> Set<TSChunk> {
        return loadedChunks
    }
    
    public func getLoadedChunkSync(at point: TSChunkPoint) -> TSChunk? {
        return loadedChunks.first(where: {$0.point == point})
    }
    
    public func playerDidMove(to point: TSVector2) {
        playerPosition = point
    }
    
    private var _updateChunkCreateLock = RMLock()
    private func _updateChunkCreate() {
        if _updateChunkCreateLock.isLocked { return } ; _updateChunkCreateLock.lock()
        
        let playerPoint = TSChunk.convertToChunkPoint(fromGlobal: playerPosition)
        let loadablePoints = self._calcurateLoadablePoints(from: playerPoint)

        for loadablePoint in loadablePoints {
            let needsToLoad = self.loadedChunks.allSatisfy({$0.point != loadablePoint})
            if needsToLoad {
                DispatchQueue.global(qos: .userInteractive).async {
                    self._loadChunkSync(at: loadablePoint)
                }
            }
        }
            
        self._updateChunkCreateLock.unlock()
        
    }
    
    
    private var _updateChunkDestoroyLock = RMLock()
    private func _updateChunkDestoroy(){
        if _updateChunkDestoroyLock.isLocked { return } ;_updateChunkDestoroyLock.lock()
        
        let playerPoint = TSChunk.convertToChunkPoint(fromGlobal: playerPosition)
        let loadablePoints = self._calcurateLoadablePoints(from: playerPoint)
        
        for loadedChunk in self.loadedChunks {
            if !loadablePoints.contains(loadedChunk.point) {
                self._unloadChunk(loadedChunk)
            }
        }
        
        _updateChunkDestoroyLock.unlock()
        
    }
    
    private init() {
        TSEventLoop.shared.register(self)
    }
    
    // ======================================================================== //
    // MARK: - Privates -
    
    private func _calcurateLoadablePoints(from point: TSChunkPoint) -> Set<TSChunkPoint> {
        let distance = TSOptionSaveData.shared.renderDistance
        
        var points = Set<TSChunkPoint>()
        
        for xd in -distance...distance {
            for zd in -distance...distance {
                points.insert(point + TSChunkPoint(Int16(xd), Int16(zd)))
            }
        }
        
        return points
    }
    
    private func _loadChunkSync(at point: TSChunkPoint) {
        guard TSChunkNodeGenerator.shared.isFreeChunk(at: point) else { return }
        
        let chunk = TSTerrainManager.shared.getChunkSync(at: point)
        
        TSChunkNodeGenerator.shared.prepare(for: chunk) {
            DispatchQueue.main.async {
                self.loadedChunks.insert(chunk)
                self.delegates.forEach { $0.chunkDidLoad(chunk) }
            }
        }
    }
    
    private func _unloadChunk(_ chunk: TSChunk) {
        guard let unloaded = self.loadedChunks.remove(chunk) else { fatalError() }
        
        self.delegates.forEach{ $0.chunkDidUnload(unloaded) }
        
        unloadedChunks.insert(unloaded)
    }
    
}

extension TSChunkLoader: TSEventLoopDelegate {
    
    static let savePerTick:UInt = 200
    
    func update(_ eventLoop: TSEventLoop, at tick: TSTick) {
        
        if tick.value % 10 == 0 {
            self._updateChunkCreate()
            self._updateChunkDestoroy()
        }
        
        // save edited
        if tick.value % TSChunkLoader.savePerTick == 0 {
            for loadedChunk in self.loadedChunks {
                if loadedChunk.isEdited {
                    loadedChunk.isEdited = false
                    TSChunkFileLoader.shared.saveChunkAsync(loadedChunk)
                }
            }
        }
        
        // save unloaded
        if tick.value % TSChunkLoader.savePerTick == TSChunkLoader.savePerTick / 2 {
            for unloaded in self.unloadedChunks {
                TSChunkFileLoader.shared.saveChunkAsync(unloaded)
            }
        }
        
    }
}
