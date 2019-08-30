//
//  TSEntity.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/29.
//  Copyright © 2019 yuki. All rights reserved.
//

import SceneKit


class TSEntity {
    
    private weak var world:TSEntityWorld!
    
    func removeFromWorld() {
        
        print("removeFromWorld")
    }
    
    init(world:TSEntityWorld) {
        self.world = world
    }
    
    func generateNode() -> SCNNode {
        fatalError()
    }
    func update(tic:Double,object:TSEntityObject, world:TSEntityWorld, level:TSLevel) {
        fatalError()
    }
}
