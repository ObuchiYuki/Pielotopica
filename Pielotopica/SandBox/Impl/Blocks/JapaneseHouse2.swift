//
//  JapaneseHouse2.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/18.
//  Copyright © 2019 yuki. All rights reserved.
//

import SceneKit
import RxCocoa
import RxSwift

// =============================================================== //
// MARK: - JapaneseHouse2 -

/**
 */
class JapaneseHouse2:TSBlock {
    // =============================================================== //
    // MARK: - Methods -
    override func getOriginalNodeSize() -> TSVector3 {
        return [3, 2, 3]
    }
    override func didPlaced(at point: TSVector3) {
        
    }
    override func didRandomEventRoopCome(at point: TSVector3) {
        
    }
    override func shouldAnimateWhenPlaced(at point: TSVector3) -> Bool {
        return true
    }
    
    // =============================================================== //
    // MARK: - Constructor -
    
    // =============================================================== //
    // MARK: - Private Methods -
}
