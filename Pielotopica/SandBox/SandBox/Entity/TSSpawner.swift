//
//  TSSpawner.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/30.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

class TSSpawner {
    let frequency:Int
    let entity:TSEntity
    
    init(frequency:Int, entity:TSEntity) {
        self.frequency = frequency
        self.entity = entity
    }
    init(block:TS_SpawnerBlock) {
        self.frequency = block.frequency
        self.entity = block.entity
    }
}
