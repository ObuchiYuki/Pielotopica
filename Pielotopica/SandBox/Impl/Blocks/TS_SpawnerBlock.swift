//
//  TS_SpawnerBlock.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/30.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

class TS_SpawnerBlock: TSBlock {
    // おおよそ100秒に何回発生させるか
    var frequency:Int = 0
    let entity:TSEntity
    
    init(frequency:Int, entity:TSEntity, index:Int) {
        self.frequency = frequency
        self.entity = entity
        
        super.init(nodeNamed: "TP_spawner_1x1", index: index)
    }
    
    override func isObstacle() -> Bool {
        return false
    }
    
    override func getOriginalNodeSize() -> TSVector3 {
        return [1, 1, 1]
    }
    
    override func canDestroy(at point: TSVector3) -> Bool {
        return true
    }
    override func shouldAnimateWhenPlaced(at point: TSVector3) -> Bool {
        return true
    }
}
