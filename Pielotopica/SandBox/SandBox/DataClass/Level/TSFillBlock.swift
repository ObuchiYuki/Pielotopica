//
//  TSFillBlock.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/31.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

public class TSFillBlock: RMAutoSavable {
    
    static let zero:TSFillBlock = TSFillBlock(anchor: .zero, index: 0)
    
    internal var anchor:TSVector3
    public var index:UInt16
    
    init(anchor:TSVector3, index:UInt16) {
        self.anchor = anchor
        self.index = index
    }
}
 
