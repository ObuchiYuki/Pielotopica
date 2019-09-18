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
    static let shared = TSChunkLoader()
    
    public var delegates = RMWeakSet<TSChunkManagerDelegate>()
    
    var playerPosition = TSVector2.zero
    
    var loadedChunks = Set<TSChunk>()
    
    // ======================================================================== //
    // MARK: - Methods -
    
    private var _updateChunkCreateLock = RMLock()
    
    private func _updateChunkCreate() {
        if _updateChunkCreateLock.isLocked { return }
        _updateChunkCreateLock.lock()
        
        let playerPoint = self._calcurateChunkPoint(from: playerPosition)
        let loadablePoints = self._calcurateLoadablePoints(from: playerPoint)

        DispatchQueue.global(qos: .userInteractive).async {
            
            for loadablePoint in loadablePoints {
                if self.loadedChunks.allSatisfy({$0.point != loadablePoint}) {
                    self._loadChunkSync(at: loadablePoint)
                }
            }
            
            self._updateChunkCreateLock.unlock()
        }
        
    }
    
    private var _updateChunkDestoroyLock = RMLock()
    
    private func _updateChunkDestoroy(){
        if _updateChunkDestoroyLock.isLocked { return }
        _updateChunkDestoroyLock.lock()
        
        let playerPoint = self._calcurateChunkPoint(from: playerPosition)
        let loadablePoints = self._calcurateLoadablePoints(from: playerPoint)
        
        for loadedChunk in self.loadedChunks {
            if !loadablePoints.contains(loadedChunk.point) {
                self._unloadChunk(loadedChunk)
            }
        }
        
        _updateChunkDestoroyLock.unlock()
        
    }
    
    public init() {
        TSEventLoop.shared.register(self)
        
        TSTick.shared.subscribe(10) {
            self._updateChunkCreate()
            self._updateChunkDestoroy()
        }
        
        TSEventLoop.shared.register(self)
    }
}

extension TSChunkLoader: TSEventLoopDelegate {
    
}
