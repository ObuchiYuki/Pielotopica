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
public class TSChunk  {
    var point: TSChunkPoint
    var fillmap = [[[UInt16]]]()
    var anchors = Set<TSVector3>()
    var anchorFill = [TSVector3: TSVector3]()
    
    
}

extension TSChunk {
    public static let sideWidth: Int16 = 16
    public static let height: Int16 = 4
    
}
