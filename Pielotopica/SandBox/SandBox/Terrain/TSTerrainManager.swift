//
//  TSTerrainManager.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/13.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

// ======================================================================== //
// MARK: - TSTerrainManagerDelegate -
public protocol TSTerrainManagerDelegate {
    func chunkDidLoad(_ chunk: TSChunk)
    func chunkDidUnload(_ chunk: TSChunk)
}

// ======================================================================== //
// MARK: - TSTerrainManager -
public class TSTerrainManager {
    
    public static let shared = TSTerrainManager()

    // ======================================================================== //
    // MARK: - Properties -
    public var delegates = RMWeakSet<TSTerrainManagerDelegate>()
    
    var playerPosition = TSVector2.zero
    
    var loadedChunks = Set<TSChunk>()
    
    // ======================================================================== //
    // MARK: - Methods -
    init() {
        TSTick.shared.subscribe {
            self._updateChunkCreate()
            self._updateChunkDesktoroy()
        }
        
        TSEventLoop.shared.register(self)
    }
    
    private func _updateChunkCreate() {
        let playerPoint = self._calcurateChunkPoint(from: playerPosition)
        let loadablePoints = self._calcurateLoadablePoints(from: playerPoint)

        for loadablePoint in loadablePoints {
            if self.loadedChunks.allSatisfy({$0.point != loadablePoint}) {
                _loadChunk(at: loadablePoint, {})
            }
        }
    }
    
    private func _updateChunkDesktoroy(){
        let playerPoint = self._calcurateChunkPoint(from: playerPosition)
        let loadablePoints = self._calcurateLoadablePoints(from: playerPoint)
        
        for loadedChunk in self.loadedChunks {
            if !loadablePoints.contains(loadedChunk.point) {
                self._unloadChunk(loadedChunk)
            }
        }
    }
    
    public func didPlayerMoved(to point: TSVector2) {
        playerPosition = point
        
    }
    
    public func chunk(contains point: TSVector2) -> TSChunk {
        let chunkPoint = _calcurateChunkPoint(from: point)
        
        return chunk(at: chunkPoint)
    }
    
    public func chunk(at point: TSChunkPoint) -> TSChunk {
        if let chunk = loadedChunks.first(where: {$0.point == point}) {
            print("loaded")
            return chunk
        }
        //if let saved = TSChunkFileLoader.shared.loadChunk(at: point) {  // 保存済み
        //    print("saved")
        //    return saved
        //}
    
        print("generated")
        let chunk = TSChunkGenerator.shared.generateChunk(for: point)
        return chunk
    }
    
    public func chunkPosition(fromGlobal point: TSVector3) -> TSVector3 {
        return _calcurateChunkPosition(from: point)
    }
    
    public func getAllAnchors() -> [TSVector3] {
        return loadedChunks.flatMap{ $0.anchors }
    }
    
    // ============================================= //
    // MARK: - FillMap Getter and Setter -
    
    // All points below is global points.
    
    public func getFill(at point:TSVector3) -> TSBlock {
        let chunk = self.chunk(contains: point.vector2)
        let (x, y, z) = self.chunkPosition(fromGlobal: point).tuple
        
        return TSBlock.block(for: chunk.fillmap[x][y][z])
    }
    
    public func setFill(_ block:TSBlock, at point:TSVector3) {
        let chunk = self.chunk(contains: point.vector2)
        chunk.isEdited = true
        let (x, y, z) = self.chunkPosition(fromGlobal: point).tuple
        
        chunk.fillmap[x][y][z] = block.index
    }
    
    // MARK: - anchoBlock Getter and Setter -
    public func removeAnchorBlock(_ point: TSVector3) {
        let chunk = self.chunk(contains: point.vector2)
        chunk.isEdited = true
        
        chunk.anchors.remove(point)
    }
    
    public func getAnchorBlock(at point:TSVector3) -> TSBlock {
        let chunk = self.chunk(contains: point.vector2)
        let chunkPos = self.chunkPosition(fromGlobal: point)
        let (x, y, z) = chunkPos.tuple
        
        guard chunk.anchors.contains(chunkPos) else {
            return .air
        }
        
        return TSBlock.block(for: chunk.fillmap[x][y][z])
    }
    
    public func setAnchorBlock(_ block:TSBlock, at point:TSVector3) {
        let chunk = self.chunk(contains: point.vector2)
        chunk.isEdited = true
        let chunkPosition = self.chunkPosition(fromGlobal: point)
        let (x, y, z) = chunkPosition.tuple
        
        chunk.anchors.insert(chunkPosition)
        chunk.fillmap[x][y][z] = block.index
    }
    
    public func setBlockData(_ data: TSBlockData, at point:TSVector3) {
        let chunk = self.chunk(contains: point.vector2)
        chunk.isEdited = true
        let (x, y, z) = self.chunkPosition(fromGlobal: point).tuple
        
        chunk.datamap[x][y][z] = data.value
    }
    
    public func getBlockData(at point:TSVector3) -> TSBlockData {
        let chunk = self.chunk(contains: point.vector2)
        let (x, y, z) = self.chunkPosition(fromGlobal: point).tuple
        
        return TSBlockData(value: chunk.datamap[x][y][z])
    }
    
    public func getAnchor(ofFill fillPoint: TSVector3) -> TSVector3? {
        let chunk = self.chunk(contains: fillPoint.vector2)
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
    public func dump() {
        print(_dump())
    }
    
    // ======================================================================== //
    // MARK: - Privates -
    
    private func _loadChunk(at point: TSChunkPoint, _ completion: @escaping ()->()) {
        guard TSChunkNodeGenerator.shared.isFreeChunk(at: point) else { return }
        
        let chunk = self.chunk(at: point)
        
        TSChunkNodeGenerator.shared.prepare(for: chunk) {
            self.loadedChunks.insert(chunk)
            
            self.delegates.forEach {
                $0.chunkDidLoad(chunk)
            }
        }
    }
    
    private func _unloadChunk(_ chunk: TSChunk) {
        guard let unloaded = self.loadedChunks.remove(chunk) else { fatalError() }
        
        self.delegates.forEach{ $0.chunkDidUnload(unloaded) }
        
        TSChunkFileLoader.shared.saveChunk(unloaded)
    }
    
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
    
    private func _calcurateChunkPosition(from globalPoint: TSVector3) -> TSVector3 {
        let chunkPoint = _calcurateChunkPoint(from: globalPoint.vector2).vector3(y: 0)
        
        let position = (globalPoint - chunkPoint).positive
        
        return position
    }
    
    private func _calcurateChunkPoint(from pointContaining: TSVector2) -> TSChunkPoint {
        
        return TSChunkPoint(pointContaining.x16 / TSChunk.sideWidth, pointContaining.z16 / TSChunk.sideWidth)
    }
    
    private func _dump() -> String {
        let dist = TSOptionSaveData.shared.renderDistance * 2 + 2
        let points = loadedChunks.map { $0.point }
        var out = ""
        
        let minX = points.map({$0.x}).min()!.i - 1
        let minZ = points.map({$0.z}).min()!.i - 1
        
        out += "\nAll Chunks\n"
        out += "x\\z |"
        for z in minZ...(minZ + dist) {
            out += String(format: "%03d ", z)
        }
        out += "\n____|"
        for _ in minZ...(minZ + dist) {
            out += "____"
        }
        
        for x in minX...(minX + dist) {
            out += "\n\(String(format: "%03d", x)) |"
            
            for z in minZ...(minZ + dist) {
                if points.contains(TSChunkPoint(Int16(x), Int16(z))) {
                    out += "  * "
                }else{
                    out += "  - "
                }
            }
        }
        
        return out
        
    }
}

extension TSTerrainManager: TSEventLoopDelegate {
    static let savePerTick:UInt = 100
    
    public func update(_ eventLoop: TSEventLoop, at tick: TSTick) {
        
        if tick.value % TSTerrainManager.savePerTick == 0 {
            for loadedChunk in self.loadedChunks {
                //TSChunkFileLoader.shared.saveChunk(loadedChunk)
            }
        }
        
    }
}
