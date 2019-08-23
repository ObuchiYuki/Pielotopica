//
//  TSWall.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/23.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

class TSWall: TSBlock {
    
    
    // =============================================================== //
    // MARK: - Methods -
    override func shouldAnimateWhenPlaced(at point: TSVector3) -> Bool {
        return true
    }
}
