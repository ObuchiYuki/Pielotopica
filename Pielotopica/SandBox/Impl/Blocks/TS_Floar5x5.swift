//
//  NormalFloar5x5.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/18.
//  Copyright © 2019 yuki. All rights reserved.
//

import SceneKit
import RxCocoa
import RxSwift

// =============================================================== //
// MARK: - NormalFloar5x5 -

/// 普通の床です。(5, 1, 5)
class TS_Floar5x5:TSBlock {
    // =============================================================== //
    // MARK: - Methods -
    override func getOriginalNodeSize() -> TSVector3 {
        return [5, 1, 5]
    }
    
    override func shouldRandomRotateWhenPlaced() -> Bool {
        return true
    }
    override func canPlaceBlockOnTop(_ block: TSBlock, at point: TSVector3) -> Bool {
        return true
    }
    override func shouldAnimateWhenPlaced(at point: TSVector3) -> Bool {
        return true
    }
}

