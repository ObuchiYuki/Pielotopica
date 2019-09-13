//
//  TSChunk.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/13.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation
 
//
public class TSChunk {
    var fillmap = [[[UInt16]]]()
    var anchors = Set<TSVector3>()
    var anchorFill = [TSVector3: TSVector3]()
    
}

extension TSChunk {
    public static let sideWidth: Int16 = 16
    
}
