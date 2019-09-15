//
//  TSChunk.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/13.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation
 
/// (x, y, z) = (16, 4, 16)
/// = 1024 blocks
public class TSChunk {
    // MARK: - Properties -
    public var point = TSChunkPoint.zero
    
    internal var fillmap:[[[UInt16]]] =
        Array(repeating: Array(repeating: Array(repeating: 0, count: TSChunk.sideWidth.i), count: TSChunk.height.i), count: TSChunk.sideWidth.i)
    
    internal var datamap:[[[UInt8]]] =
        Array(repeating: Array(repeating: Array(repeating: 0, count: TSChunk.sideWidth.i), count: TSChunk.height.i), count: TSChunk.sideWidth.i)
    
    internal var fillAnchors:[[[TSVector3?]]] =
        Array(repeating: Array(repeating: Array(repeating: nil, count: TSChunk.sideWidth.i), count: TSChunk.height.i), count: TSChunk.sideWidth.i)
        
    internal var anchors     = Set<TSVector3>()

    // MARK: - Methods -
    
    public func getFillBlock(at chunkPoint: TSVector3) -> TSBlock {
        let (x, y, z) = chunkPoint.tuple
        let blockIndex = fillmap[x][y][z]
            
        return TSBlock.block(for: blockIndex)
    }
    
    public func getRotation(at chunkPoint: TSVector3) -> TSBlockRotation {
        return TSBlockRotation(data: getBlockData(at: chunkPoint))
    }
    
    public func getBlockData(at chunkPoint: TSVector3) -> TSBlockData {
        let (x, y, z) = chunkPoint.tuple
        let blockData = datamap[x][y][z]
        
        return TSBlockData(value: blockData)
    }
    
    public func getAnchorPoint(ofFill chunkPoint: TSVector3) -> TSVector3? {
        let (x, y, z) = chunkPoint.tuple
        
        return fillAnchors[x][y][z]
    }
    
    public func getAnchors() -> Set<TSVector3> {
        return anchors
    }
    
    public func makeGlobal(_ chunkPoint: TSVector3) -> TSVector3 {
        
    }
}

extension TSChunk {
    public static let sideWidth: Int16 = 16
    public static let height: Int16 = 4
    
}

extension TSChunk: Equatable {
    public static func == (left: TSChunk, right: TSChunk) -> Bool {
        return left.point == right.point
    }
}
