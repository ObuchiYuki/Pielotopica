//
//  TS_FuelFactory.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/02.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

class TS_FuelFactory: TSBlock {
    override func getOriginalNodeSize() -> TSVector3 {
        return [3, 3, 3]
    }
    override func getHardnessLevel() -> Int {
        return 20
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
