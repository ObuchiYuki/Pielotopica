//
//  TSSpawnerBlock.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/30.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

class TSSpawnerBlock: TSBlock {
    // おおよそ100秒に何回発生させるか
    var frequency:Int = 0
    
    func getSpawnEntity() -> TSEntity {
        fatalError()
    }
    
}
