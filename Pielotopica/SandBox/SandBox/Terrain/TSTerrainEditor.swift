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
        
        delegates.forEach{$0.level(self, levelDidUpdateBlockAt: anchor, needsAnimation: true, withRotation: rotation)}
        
        block.didPlaced(at: anchor)
        
        //self._save()
    }
    
    @discardableResult
    public func destoryBlock(at anchor: TSVector3) -> Bool {
        return true
    }
    
    // MARK: - Privates -
    
    private func _placeAnchor(_ block: TSBlock, anchor:TSVector3) {
        let chunk = TSChunkManager.shared.chunk(contains: anchor.vector2)
        
        //...
    }
}
