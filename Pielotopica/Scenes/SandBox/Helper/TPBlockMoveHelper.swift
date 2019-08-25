//
//  TPBlockMoveHelper.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/24.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

class TPBlockMoveHelper: TPBlockEditHelper {
    private var _backupStartPoint:TSVector3!
    private var _backupRotation:TSBlockRotation!
    
    func startMoving(at startPoint:TSVector3) {
        let blockData = level.getBlockData(at: startPoint)
        let rotation = TSBlockRotation(data: blockData)
        
        _backupStartPoint = startPoint
        _backupRotation = rotation
    
        level.destroyBlock(at: startPoint)
        
        startEditing(from: startPoint, startRotation: rotation.rotation)
    }
    
    override func _placeBlock() {
        if canEndBlockEditing() {
            self.level.placeBlock(block, at: _nodePosition, rotation: _roataion)
        }else{
            self.level.placeBlock(block, at: _backupStartPoint, rotation: _backupRotation)
        }
    }
}
