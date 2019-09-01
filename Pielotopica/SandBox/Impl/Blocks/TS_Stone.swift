//
//  TS_Stone.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/01.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

class TS_Stone: TSBlock {
    // =============================================================== //
    // MARK: - Methods -
    override func getOriginalNodeSize() -> TSVector3 {
        return [1, 1, 1]
    }
    override func getHardnessLevel() -> Int {
        return 100
    }
    override func shouldRandomRotateWhenPlaced() -> Bool {
        return true
    }
    override func isObstacle() -> Bool {
        return false
    }
    override func canDestroy(at point: TSVector3) -> Bool {
        return false
    }
    override func shouldAnimateWhenPlaced(at point: TSVector3) -> Bool {
        return false
    }
}

