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

/// `Async` と書いてあるものは非同期スレッドから呼びだしていい
/// `Sync`と書いてあるのはmainからしか呼び出せない
/// `Sync_Async`と書いてあるのは同期的に動くが非同期スレッドから呼びだしていい
/// あらゆるコールバックは main で行われる必要がある。
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
    
    public func getLoadedChunkAsync(at point: TSChunkPoint,_  completion: @escaping (TSChunk?) -> () ) {
        
        DispatchQueue.main.async {
            let chunk = self.getLoadedChunkSync(at: point)
            
            completion(chunk)
        }
        
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
        
        let loadedPoints = self.loadedChunks.map{ $0.point }
            
        var loadPoints = loadablePoints.filter { loadable in loadedPoints.allSatisfy({ $0 != loadable }) }
        
        func _loadChunk() {
            DispatchQueue.main.async {
                guard let loadPoint = loadPoints.popFirst() else { return }
                
                DispatchQueue.global(qos: .userInteractive).async {
                    self._loadChunkSync_Async(at: loadPoint) { _loadChunk() }
                }
            }
        }
        
        _loadChunk()
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
    
    private func _loadChunkSync_Async(at point: TSChunkPoint, _ completion: @escaping ()->()) {
        DispatchQueue.main.async {
            guard TSChunkNodeGenerator.shared.isFreeChunk(at: point) else { return }
            
            TSTerrainManager.shared.getChunkAsync(at: point) { chunk in
                
                TSChunkNodeGenerator.shared.prepareAsync(for: chunk) {
                    self.loadedChunks.append(chunk)
                    self.delegates.forEach { $0.chunkDidLoad(chunk) }
                    
                    completion()
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
    
    static let savePerTick:UInt = 300
    
    private func _saveAllChunk() {
        DispatchQueue.main.async {
    
            guard let last = self.unloadedChunks.popLast() else { return }
            
            DispatchQueue.global(qos: .background).async {
                TSChunkFileLoader.shared.saveChunkSync_Async(last)
                    
                self._saveAllChunk()
            }
        }
    }
    
    private func _saveEditedChunk() {
        __saveEditedChunk(0)
    }
    
    private func __saveEditedChunk(_ repeatIndex: Int) {
        DispatchQueue.main.async {
            guard let loaded = self.loadedChunks.at(repeatIndex) else { return }
            if loaded.isEdited {
                loaded.isEdited = false
                
                DispatchQueue.global(qos: .background).async {
                    TSChunkFileLoader.shared.saveChunkSync_Async(loaded)
                    
                    self.__saveEditedChunk(repeatIndex + 1)
                }
            }
            
        }
    }
    
    func update(_ eventLoop: TSEventLoop, at tick: TSTick) {
        
        if tick.value % 10 == 0 {
            self._updateChunkCreate()
            self._updateChunkDestoroy()
        }
        
        // save edited
        if tick.value % TSChunkLoader.savePerTick == 0 {
            self._saveEditedChunk()
        }
        
        // save unloaded
        if tick.value % TSChunkLoader.savePerTick == TSChunkLoader.savePerTick / 2 {
            self._saveAllChunk()
        }
        
    }
}
