//
//  TPBlockMoveHelper.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/24.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

class TPBlockMoveHelper: TPBlockEditHelper {
    func startMoving(at startPoint:TSVector3) {
        let blockData = level.getBlockData(at: startPoint)
    
        level.destroyBlock(at: startPoint)
        
        startEditing(from: startPoint, startRotation: TSBlockRotation(data: blockData).rotation)
    }
}
