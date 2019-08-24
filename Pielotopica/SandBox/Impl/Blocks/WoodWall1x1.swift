//
//  WoodBlock.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/24.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

class TSWall1: TSBlock {
    
    
    // =============================================================== //
    // MARK: - Methods -
    override func getOriginalNodeSize() -> TSVector3 {
        return [1, 1, 1]
    }
    override func shouldAnimateWhenPlaced(at point: TSVector3) -> Bool {
        return true
    }
}
