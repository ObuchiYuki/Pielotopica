//
//  TSTerrainEditor.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/13.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation


// ======================================================================== //
// MARK: - TSTerrainEditorDelegate -
public protocol TSTerrainEditorDelegate {
    func editor(editorDidUpdateBlockAt position:TSVector3, needsAnimation :Bool, withRotation rotation:TSBlockRotation)
    func editor(editorWillDestroyBlockAt position:TSVector3, needsAnimation :Bool)
    func editor(editorDidDestroyBlockAt position:TSVector3, needsAnimation :Bool)
}

// MARK: - Make Optional -
public extension TSTerrainEditorDelegate {
    func editor(editorDidUpdateBlockAt position:TSVector3, needsAnimation animiationFlag:Bool, withRotation rotation:TSBlockRotation) {}
    func editor(editorWillDestroyBlockAt position:TSVector3, needsAnimation :Bool) {}
    func editor(editorDidDestroyBlockAt position:TSVector3, needsAnimation :Bool) {}
}

// ======================================================================== //
// MARK: - TSTerrainEditor -

public class TSTerrainEditor {
    // MARK: - Singleton -
    public static let shared = TSTerrainEditor()
    
    public var delegates = RMWeakSet<TSTerrainEditorDelegate>()
    
    private let manager = TSTerrainManager.shared
    // ======================================================================== //
    // MARK: - Methods -
    
    public func canPlaceBlock(_ block:TSBlock, at anchor:TSVector3, rotation:TSBlockRotation) -> Bool {
        guard block.canPlace(at: anchor) else { return false }
        guard !_conflictionExsists(about: block, at: anchor, at: rotation) else { return false }
        
        return true
    }
    
    @discardableResult
    public func placeBlock(_ block:TSBlock, at anchor:TSVector3, rotation:TSBlockRotation, forced:Bool = false) -> Bool {
        var rotation = rotation
        var anchor = anchor
        
        if !forced {
            guard block.canPlace(at: anchor) else {
                log.error("Block placing failture. \(block)")
                return false
            }
            guard !_conflictionExsists(about: block, at: anchor, at: rotation) else {
                log.error("Block placing failture. Conflication exsists at \(anchor) of \(block).")
                return false
            }
        }
        
        if block.shouldRandomRotateWhenPlaced() {
            
            rotation = TSBlockRotation.random
            
            anchor = TSModelRotator.shared.calcurateAnchorPoint(
                blockSize: block.getSize(at: anchor),
                initial: anchor,
                for: rotation
            )
        }
        
        self._writeRotation(rotation, at: anchor)
        
        block.willPlace(at: anchor)
            
        manager.setAnchorBlock(block, at: anchor)
        
        self._fillFillMap(with: block, at: anchor, blockSize: block.getSize(at: anchor))
        
        delegates.forEach{ $0.editor(editorDidUpdateBlockAt: anchor, needsAnimation: true, withRotation: rotation) }
        
        block.didPlaced(at: anchor)
        
        return true
    }
    
    @discardableResult
    public func destroyBlock(at anchor: TSVector3) -> Bool {
        let block = TSTerrainManager.shared.getAnchorBlock(at: anchor)
        
        guard block.canDestroy(at: anchor) else {
            log.error("Block destraction failed.")
            return false
        }
                
        block.willDestroy(at: anchor)
        delegates.forEach{ $0.editor(editorWillDestroyBlockAt: anchor, needsAnimation: true) }
        
        //self.nodeGenerator?.destoryNode(at: anchor)
        TSTerrainManager.shared.removeAnchorBlock(anchor)
        TSTerrainManager.shared.setAnchorBlock(.air, at: anchor)
        self._fillFillMap(with: .air, at: anchor, blockSize: block.getSize(at: anchor))
        TSTerrainManager.shared.setBlockData(TSBlockData() , at: anchor)
        
        delegates.forEach{ $0.editor(editorDidDestroyBlockAt: anchor, needsAnimation: true) }
        
        block.didDestroy(at: anchor)
        
        return true
    }
    
    // ======================================================================== //
    // MARK: - Constructor -
    
    private init() {
        TSChunkLoader.shared.delegates.append(self)
    }
    
    // ======================================================================== //
    // MARK: - Privates -
    
    private func _conflictionExsists(about block:TSBlock, at anchorPoint:TSVector3, at rotation:TSBlockRotation) -> Bool {
        let size = block.getSize(at: anchorPoint, at: rotation)
        
        for x in OptimazedRange(size.x16) {
            for y in OptimazedRange(size.y16) {
                for z in OptimazedRange(size.z16) {
                    
                    if TSTerrainManager.shared.getFill(at: anchorPoint + TSVector3(x, y, z)) != .air {
                        return true
                    }
                }
            }
        }
        
        return false
    }
    
    private func _writeRotation(_ rotation:TSBlockRotation, at point:TSVector3) {
        var data = TSBlockData()
        rotation.setData(to: &data)
        
        TSTerrainManager.shared.setBlockData(data, at: point)
    }
    
    private func _fillFillMap(with block:TSBlock, at anchorPoint:TSVector3, blockSize size:TSVector3) {
        
        for xSize in OptimazedRange(size.x16) {
            for ySize in OptimazedRange(size.y16) {
                for zSize in OptimazedRange(size.z16) {
                    
                    manager.setFill(block, at: anchorPoint + TSVector3(xSize, ySize, zSize))
                }
            }
        }
    }
}

extension TSTerrainEditor: TSChunkLoaderDelegate {
    public func chunkDidLoad(_ chunk: TSChunk) {
        for anchor in chunk.anchors {
            let rotation = chunk.getRotation(at: anchor)
            let global = chunk.makeGlobal(anchor)
                                
            self.delegates.forEach{ $0.editor(editorDidUpdateBlockAt: global, needsAnimation: false, withRotation: rotation) }
        }
    }
    
    public func chunkDidUnload(_ chunk: TSChunk) {
        
        for anchor in chunk.anchors {
            self.delegates.forEach{ $0.editor(editorWillDestroyBlockAt: chunk.makeGlobal(anchor), needsAnimation: false) }
            self.delegates.forEach{ $0.editor(editorDidDestroyBlockAt:  chunk.makeGlobal(anchor), needsAnimation: false) }
        }
    }
}
