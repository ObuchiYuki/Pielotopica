//
//  TS_House.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/02.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

class TS_House: TSBlock {
    // =============================================================== //
    // MARK: - Methods -
    override func getOriginalNodeSize() -> TSVector3 {
        return [2, 2, 2]
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


