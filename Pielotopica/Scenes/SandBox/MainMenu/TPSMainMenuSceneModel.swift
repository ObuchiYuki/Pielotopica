//
//  TPSMainMenuSceneModel.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/28.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

protocol TPSMainMenuSceneModelBinder:class {
    
}

class TPSMainMenuSceneModel {
    // ===================================================================== //
    // MARK: - Properties -
    private weak var binder:TPSMainMenuSceneModelBinder!
    
    // ===================================================================== //
    // MARK: - Constructor -
    init(_ binder:TPSMainMenuSceneModelBinder) {
        self.binder = binder
    }
    
    // ===================================================================== //
    // MARK: - Handler -
    
    func onMenuItemTap() {
        
    }
    func onBuildItemTap() {
        
    }
    func onCaptureItemTap() {
        
    }
    func onShopItemTap() {
        
    }
    
    
}
