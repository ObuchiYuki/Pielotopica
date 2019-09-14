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
    
    private var fillmap     = [[[UInt16]]]()
    private var data        = [[[UInt8]]]()
    private var anchors     = Set<TSVector3>()
    private var anchormap   = [[[UInt16]]]()

    // MARK: - Methods -
    public func getFillBlock(at chunkPoint: TSVector3) -> TSBlock {
        let (x, y, z) = chunkPoint.tuple
        let blockIndex = fillmap[x][y][z]
            
        return TSBlock.block(for: blockIndex)
    }
    
    public func getAnchors() -> Set<TSVector3> {
        return anchors
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
