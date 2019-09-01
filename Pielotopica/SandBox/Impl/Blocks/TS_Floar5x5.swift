//
//  NormalFloar6x6.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/18.
//  Copyright © 2019 yuki. All rights reserved.
//

import SceneKit
import RxCocoa
import RxSwift

// =============================================================== //
// MARK: - NormalFloar6x6 -

/// 普通の床です。(6, 1, 6)
class TS_Floar6x6:TSBlock {
    // =============================================================== //
    // MARK: - Methods -
    override func getOriginalNodeSize() -> TSVector3 {
        return [6, 1, 6]
    }
    
    override func shouldRandomRotateWhenPlaced() -> Bool {
        return false
    }
    override func canPlaceBlockOnTop(_ block: TSBlock, at point: TSVector3) -> Bool {
        return true
    }
    override func shouldAnimateWhenPlaced(at point: TSVector3) -> Bool {
        return true
    }
}

