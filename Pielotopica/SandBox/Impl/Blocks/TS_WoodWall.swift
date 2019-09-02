//
//  TSWall.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/23.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

class TS_WoodWall: TSBlock {
    
    
    // =============================================================== //
    // MARK: - Methods -
    override func getOriginalNodeSize() -> TSVector3 {
        return [1, 1, 5]
    }
    override func getHardnessLevel() -> Int {
        return 100
    }
    override func isObstacle() -> Bool {
        true
    }
    override func canDestroy(at point: TSVector3) -> Bool {
        return true
    }
    override func shouldAnimateWhenPlaced(at point: TSVector3) -> Bool {
        return true
    }
}
