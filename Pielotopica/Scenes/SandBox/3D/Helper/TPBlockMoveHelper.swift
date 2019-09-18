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
        let blockData = manager.getBlockData(at: startPoint)
        let rotation = TSBlockRotation(data: blockData)
        
        _backupStartPoint = startPoint
        _backupRotation = rotation
    
        editor.destroyBlock(at: startPoint)
        
        startEditing(from: startPoint, startRotation: rotation.rotation)
    }
    
    override func _placeBlock() {
        if canEndBlockEditing() {
            self.editor.placeBlock(block, at: _nodePosition, rotation: _roataion)
        }else{
            self.editor.placeBlock(block, at: _backupStartPoint, rotation: _backupRotation)
        }
    }
}
