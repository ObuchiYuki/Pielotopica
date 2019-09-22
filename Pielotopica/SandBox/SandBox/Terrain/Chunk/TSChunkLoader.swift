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
    func renderChunk(_ chunk: TSChunk)
    func unrenderChunk(_ chunk: TSChunk)
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
    
    private var renderingPoints = [TSChunkPoint]()
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
        
    // ======================================================================== //
    // MARK: - Constructors -
    private init() {
        TSEventLoop.shared.register(self)
    }
    
    // ======================================================================== //
    // MARK: - Privates -
    
    // MARK: - Load chunk handlers -
    
    private var _updateChunkRenderLock = RMLock()
    private func _updateChunkRender() {
        if _updateChunkRenderLock.isLocked { return } ; _updateChunkRenderLock.lock()
        
        let playerPoint = TSChunk.convertToChunkPoint(fromGlobal: playerPosition)
        let rendalablePoints = self._calcurateRendalablePoints(from: playerPoint)
            
        var renderPoints = rendalablePoints.filter { rendalable in renderingPoints.allSatisfy({ $0 != rendalable }) }
        
        func _renderChunk() {
            DispatchQueue.main.async {
                guard let renderPoint = renderPoints.popLast() else { return self._updateChunkRenderLock.unlock() }
                
                DispatchQueue.global(qos: .userInitiated).async {
                    
                    guard let chunk = self.loadedChunks.first(where: { $0.point == renderPoint }) else { return }
                    
                    self._renderChunkSync_Async(chunk) {
                        _renderChunk()
                    }
                }
            }
        }
        
        _renderChunk()
        
        _updateChunkRenderLock.unlock()
    }
    
    
    private var _updateChunkCreateLock = RMLock()
    private func _updateChunkCreate() {
        if _updateChunkCreateLock.isLocked { return } ; _updateChunkCreateLock.lock()
        
        let playerPoint = TSChunk.convertToChunkPoint(fromGlobal: playerPosition)
        let loadablePoints = self._calcurateLoadablePoints(from: playerPoint)
        
        let loadedPoints = self.loadedChunks.map{ $0.point }
            
        var loadPoints = loadablePoints.filter { loadable in loadedPoints.allSatisfy({ $0 != loadable }) }
        
        func _loadChunk() {
            DispatchQueue.main.async {
                guard let loadPoint = loadPoints.popLast() else { return self._updateChunkCreateLock.unlock() }
                
                DispatchQueue.global(qos: .userInitiated).async {
                    self._loadChunkSync_Async(at: loadPoint) {
                        
                        _loadChunk()
                    }
                }
            }
        }
        
        _loadChunk()
    }
    
    private func _updateChunkUnrender() {
        let playerPoint = TSChunk.convertToChunkPoint(fromGlobal: playerPosition)
        let rendalablePoints = self._calcurateRendalablePoints(from: playerPoint)
        
        let unrenderPoints = renderingPoints.filter{ rendered in !rendalablePoints.contains(rendered)}
        
        for unrenderPoint in unrenderPoints {
            guard let unrender = loadedChunks.first(where: { $0.point ==  unrenderPoint }) else { return }
            
            self._unrenderChunkSync(unrender)
        }
    }
    
    private func _updateChunkDestoroy(){
        let playerPoint = TSChunk.convertToChunkPoint(fromGlobal: playerPosition)
        let loadablePoints = self._calcurateLoadablePoints(from: playerPoint)
        
        let unloadChunks = loadedChunks.filter{ loadedChunk in !loadablePoints.contains(loadedChunk.point)}
        
        for unloadChunk in unloadChunks {
            self._unloadChunkSync(unloadChunk)
        }
    }
    
    // MARK: - Calcuration Methods -
    private func _calcurateRendalablePoints(from point: TSChunkPoint) -> [TSChunkPoint] {
        let distance = TSOptionSaveData.shared.renderDistance
        
        return _calcuratePoints(from: point, distance: distance)
    }
    
    private func _calcurateLoadablePoints(from point: TSChunkPoint) -> [TSChunkPoint] {
        let distance = TSOptionSaveData.shared.loadingDistance
        
        return _calcuratePoints(from: point, distance: distance)
    }
    
    private func _calcuratePoints(from point: TSChunkPoint, distance: Int) -> [TSChunkPoint] {
        var points = [TSChunkPoint]()
        
        for xd in -distance...distance {
            for zd in -distance...distance {
                points.append(point + TSChunkPoint(Int16(xd), Int16(zd)))
            }
        }
        
        return points
    }
    
    
    // MARK: - Real Loading Methods -
    private func _renderChunkSync_Async(_ chunk: TSChunk, completion: @escaping ()->()) {
        DispatchQueue.main.async {
            self.delegates.forEach { $0.renderChunk(chunk) }
            
            completion()
        }
    }
    
    private func _loadChunkSync_Async(at point: TSChunkPoint, _ completion: @escaping ()->() ) {
        DispatchQueue.main.async {
            guard TSChunkNodeGenerator.shared.isFreeChunk(at: point) else { return }
            
            TSTerrainManager.shared.getChunkAsync(at: point) { chunk in
                
                TSChunkNodeGenerator.shared.prepareAsync(for: chunk) {
                    self.loadedChunks.append(chunk)
                    completion()
                }
                
            }
        }
    }
    
    private func _unrenderChunkSync(_ chunk: TSChunk) {
        guard let _ = renderingPoints.remove(of: chunk.point) else { fatalError() }
        
        self.delegates.forEach{ $0.unrenderChunk(chunk) }
    }
    
    private func _unloadChunkSync(_ chunk: TSChunk) {
        guard let unloaded = self.loadedChunks.remove(of: chunk) else { fatalError() }
        
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
            self._updateChunkRender()
            self._updateChunkUnrender()
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
