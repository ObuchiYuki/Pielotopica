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
    private var loadedChunks = [TSChunk]()
    private var unloadedChunks = [TSChunk]()
    
    private var playerPosition = TSVector2.zero
    
    // ======================================================================== //
    // MARK: - Methods -
    
    public func getAllLoadedChunks() -> [TSChunk] {
        return loadedChunks
    }
    
    public func getLoadedChunkSync(at point: TSChunkPoint) -> TSChunk? {
        if let unloaded = unloadedChunks.first(where: {$0.point == point}) {
            unloadedChunks.remove(of: unloaded)
            loadedChunks.append(unloaded)
            
            return unloaded
        }
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

        // コールバック地獄ぇぇ async await 早く導入して...
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            for loadablePoint in loadablePoints {
                DispatchQueue.main.async {
                    let needsToLoad = self.loadedChunks.allSatisfy({$0.point != loadablePoint})
                    
                    DispatchQueue.global(qos: .userInteractive).async {

                        if needsToLoad {
                            self._loadChunkSync(at: loadablePoint)
                        }
                        
                    }
                    
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
        DispatchQueue.main.async {
            guard TSChunkNodeGenerator.shared.isFreeChunk(at: point) else { return }
            
            DispatchQueue.global(qos: .userInteractive).async {
                let chunk = TSTerrainManager.shared.getChunkSync(at: point)
                
                TSChunkNodeGenerator.shared.prepare(for: chunk) {
                    DispatchQueue.main.async {
                        self.loadedChunks.append(chunk)
                        self.delegates.forEach { $0.chunkDidLoad(chunk) }
                    }
                }
                
            }
        }
    }
    
    private func _unloadChunk(_ chunk: TSChunk) {
        guard let unloaded = self.loadedChunks.remove(of: chunk) else { fatalError() }
        
        self.delegates.forEach{ $0.chunkDidUnload(unloaded) }
        
        unloadedChunks.append(unloaded)
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
            while !unloadedChunks.isEmpty {
                guard let last = unloadedChunks.popLast() else {
                    return
                }
                
                TSChunkFileLoader.shared.saveChunkAsync(last)
            }
        }
        
    }
}
