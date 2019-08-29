//
//  TPSCraftSceneModel.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/28.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

protocol TPSCraftSceneModelBinder: class{
    
}

class TPSCraftSceneModel: TPSandBoxSceneModel {
    private weak var binder:TPSCraftSceneModelBinder!
    
    init(_ binder:TPSCraftSceneModelBinder) {
        self.binder = binder
    }
    
    func onBackAction() {
        self.rootSceneModel.present(to: TPSBuildScene(), as: .build)
    }
}
