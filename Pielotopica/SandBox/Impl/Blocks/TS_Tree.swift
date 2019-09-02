//
//  TS_Tree.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/31.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

class TS_Tree: TSBlock {
    // =============================================================== //
    // MARK: - Methods -
    override func getOriginalNodeSize() -> TSVector3 {
        return [1, 2, 1]
    }
    override func getHardnessLevel() -> Int {
        return 100
    }
    override func isObstacle() -> Bool {
        true
    }
    override func canDestroy(at point: TSVector3) -> Bool {
        true
    }
    override func shouldRandomRotateWhenPlaced() -> Bool {
        true
    }
    override func shouldAnimateWhenPlaced(at point: TSVector3) -> Bool {
        true
    }
}
