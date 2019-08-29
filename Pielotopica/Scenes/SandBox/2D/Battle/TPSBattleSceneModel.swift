//
//  File.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/29.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

protocol TPSBattleSceneModelBinder: class {
    
}

class TPSBattleSceneModel: TPSandBoxSceneModel {
    private weak var binder:TPSBattleSceneModelBinder!
    
    init(_ binder:TPSBattleSceneModelBinder) {
        self.binder = binder
    }
}
