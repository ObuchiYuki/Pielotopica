//
//  TS_TargetBlock.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/30.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

class TS_TargetBlock: TSBlock {

    override func getOriginalNodeSize() -> TSVector3 {
        return [1, 1, 1]
    }
    
    override func canDestroy(at point: TSVector3) -> Bool {
        return true
    }
}
