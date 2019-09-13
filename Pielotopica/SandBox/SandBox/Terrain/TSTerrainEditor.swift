//
//  TSTerrainEditor.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/13.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

public class TSTerrainEditor {
    public static let shared = TSChunkEditor()
    
    @discardableResult
    public func placeBlock(into chunk: TSChunk, block: TSBlock, at position: TSVector3, rotation: TSBlockRotation) -> Bool {
        assert(position.x16 < 16, "Given position's 'x' component \(position.x16) excees chunk size.")
        assert(position.y16 < 16, "Given position's 'y' component \(position.y16) excees chunk size.")
        assert(position.z16 < 16, "Given position's 'z' component \(position.z16) excees chunk size.")
        
        
        
        return true
    }
    
    @discardableResult
    public func destoryBlock(from chunk: TSChunk, at position: TSVector3) -> Bool {
        return true
    }
}
