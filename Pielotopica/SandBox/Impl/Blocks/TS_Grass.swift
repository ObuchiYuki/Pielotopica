//
//  TS_grass.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/01.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

class TS_Grass: TSBlock {
    // =============================================================== //
    // MARK: - Methods -
    override func getOriginalNodeSize() -> TSVector3 {
        return [1, 1, 1]
    }
    override func getHardnessLevel() -> Int {
        return 20
    }
    override func shouldRandomRotateWhenPlaced() -> Bool {
        return true
    }
    override func isObstacle() -> Bool {
        return true
    }
    override func canDestroy(at point: TSVector3) -> Bool {
        return true
    }
    override func shouldAnimateWhenPlaced(at point: TSVector3) -> Bool {
        return true
    }
}

