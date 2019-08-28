//
//  TPSBuildSceneModel.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/28.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

protocol TPSBuildSceneModelBinder: class {
    
}

class TPSBuildSceneModel: TPSandBoxSceneModel {
    // ===================================================================== //
    // MARK: - Properties -
    private weak var binder:TPSBuildSceneModelBinder!
    
    // ===================================================================== //
    // MARK: - Constructor -
    init(_ binder:TPSBuildSceneModelBinder) {
        self.binder = binder
    }
    
    // ===================================================================== //
    // MARK: - Handler -
    
    func onBackButtonTap() {
        
    }
    func onPlaceButtonTap() {
        
    }
    func onMoveButtonTap() {
        
    }
    func onDestoryButtonTap() {
        
    }
    func onMoreButtonTap() {
        
    }
    func onRotateButtonTap() {
        
    }
}
