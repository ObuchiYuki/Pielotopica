//
//  File.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/29.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

protocol TPSButtleSceneModelBinder: class {
    
}

class TPSButtleSceneModel: TPSandBoxSceneModel {
    private weak var binder:TPSButtleSceneModelBinder!
    
    init(_ binder:TPSButtleSceneModelBinder) {
        self.binder = binder
    }
}
