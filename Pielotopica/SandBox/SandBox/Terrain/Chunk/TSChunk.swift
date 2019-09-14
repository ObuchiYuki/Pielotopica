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
    
    public var fillmap     = [[[UInt16]]]()
    public var data        = [[[UInt8]]]()
    public var anchors     = Set<TSVector3>()
    public var anchorMap   = [[[UInt16]]]()

    // MARK: - Methods -
    func getFillBlock(at chunkPoint: TSVector3) -> TSBlock {
        
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
