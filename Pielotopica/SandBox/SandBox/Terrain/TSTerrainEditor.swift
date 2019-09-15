//
//  TSTerrainEditor.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/13.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

public protocol TSTerrainEditorDelegate {
    func editor(levelDidUpdateBlockAt position:TSVector3, needsAnimation animiationFlag:Bool, withRotation rotation:TSBlockRotation)
    func editor(levelWillDestoryBlockAt position:TSVector3)
    func editor(levelDidDestoryBlockAt position:TSVector3)
}

// MARK: - TSTerrainEditor -

public class TSTerrainEditor {
    // MARK: - Singleton -
    public static let shared = TSTerrainEditor()
    
    public var delegates = RMWeakSet<TSTerrainEditorDelegate>()
    
    // MARK: - Methods -
    
    @discardableResult
    public func placeBlock(_ block:TSBlock, at anchor:TSVector3, rotation:TSBlockRotation, forced:Bool = false) -> Bool {
        var rotation = rotation
        var anchor = anchor
        
        if block.shouldRandomRotateWhenPlaced() {
            
            rotation = TSBlockRotation.random
            
            anchorPoint = TSModelRotator.shared.calcurateAnchorPoint(
                blockSize: block.getSize(at: anchorPoint),
                initial: anchor,
                for: rotation
            )
        }
        
        self._writeRotation(rotation, at: anchor)
        
        block.willPlace(at: anchor)
        
        self.anchorMap.insert(anchorPoint)
        self._setAnchoBlockMap(block, at: anchor)
        self._fillFillMap(with: block, at: anchor, blockSize: block.getSize(at: anchor))
        
        delegates.forEach{$0.editor(levelDidUpdateBlockAt: anchor, needsAnimation: true, withRotation: rotation)}
        
        block.didPlaced(at: anchor)
        
        //self._save()
    }
    
    @discardableResult
    public func destoryBlock(at anchor: TSVector3) -> Bool {
        return true
    }
    
    // MARK: - Privates -
    
    private func _createRange(_ value:Int16) -> Range<Int16> {
        if value > 0 {
            return Range(uncheckedBounds: (lower: 0       , upper: value))
        }else{
            return Range(uncheckedBounds: (lower: value+1 , upper: 1    ))
        }
    }
    
    private func _writeRotation(_ rotation:TSBlockRotation, at point:TSVector3) {
        var data = TSBlockData()
        rotation.setData(to: &data)
        
        setBlockData(data, at: point)
    }
    
    private func _conflictionExsists(about block:TSBlock, at anchorPoint:TSVector3, at rotation:TSBlockRotation) -> Bool {
        let size = block.getSize(at: anchorPoint, at: rotation)
        
        for x in _createRange(size.x16) {
            for y in _createRange(size.y16) {
                for z in _createRange(size.z16) {
                    
                    if _getFillMap(at: anchorPoint + TSVector3(x, y, z)) != .air {
                        return true
                    }
                }
            }
        }
        
        return false
    }

    
    private func _fillFillMap(with block:TSBlock, at anchorPoint:TSVector3, blockSize size:TSVector3) {
        
        for xSize in _createRange(size.x16) {
            for ySize in _createRange(size.y16) {
                for zSize in _createRange(size.z16) {
                    
                    self._setFillMap(block, anchorPoint, at: anchorPoint + TSVector3(xSize, ySize, zSize))
                }
            }
        }
    }
        
    
    // MARK: - FillMap Getter and Setter -
    // All points below is global points.
    
    private func _getFillMap(at point:TSVector3) -> TSBlock {
        let chunk = TSChunkManager.shared.chunk(contains: point.vector2)
        let (x, y, z) = TSChunkManager.shared.chunkPosition(fromGlobal: point).tuple
        
        return TSBlock.block(for: chunk.fillmap[x][y][z])
    }
    private func _setFillMap(_ block:TSBlock,_ anchor:TSVector3, at point:TSVector3) {
        let chunk = TSChunkManager.shared.chunk(contains: point.vector2)
        let (x, y, z) = TSChunkManager.shared.chunkPosition(fromGlobal: point).tuple
        
        chunk.fillmap[x][y][z] = block.index
    }
    
    // MARK: - anchoBlock Getter and Setter -
    private func _getAnchorBlock(at point:TSVector3) -> TSBlock {
        let chunk = TSChunkManager.shared.chunk(contains: point.vector2)
        let (x, y, z) = TSChunkManager.shared.chunkPosition(fromGlobal: point).tuple
        
        guard chunk.anchors.contains(point) else { return .air }
        
        return TSBlock.block(for: chunk.fillmap[x][y][z])
    }
    
    private func _setAnchoBlock(_ block:TSBlock, at point:TSVector3) {
        let chunk = TSChunkManager.shared.chunk(contains: point.vector2)
        let (x, y, z) = TSChunkManager.shared.chunkPosition(fromGlobal: point).tuple
        
        chunk.fillmap[x][y][z] = block.index
    }
    
    private func _setBlockDataMap(_ data: UInt8, at point:TSVector3) {
        let (x, y, z) = _convertVector3(point)
        
        blockDataMap[x][y][z] = data
    }
    
    private func _getBlockDataMap(at point:TSVector3) -> UInt8 {
        let (x, y, z) = _convertVector3(point)
        
        return blockDataMap.at(x)?.at(y)?.at(z) ?? 0
    }
    
    
    /// TSVector3を配列アクセス用のIndexに変換します。
    public func _convertGlobalVector3(_ vector3:TSVector3) -> (Int, Int, Int, TSChunk) {
        let chunk = TSChunkManager.shared.chunk(contains: vector3.vector2)
        
        
        return (vector3.x + kArrayAccessMargin, vector3.y, vector3.z + kArrayAccessMargin)
    }
}
