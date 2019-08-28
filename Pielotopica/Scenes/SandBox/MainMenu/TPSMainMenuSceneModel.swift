//
//  TPSMainMenuSceneModel.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/28.
//  Copyright © 2019 yuki. All rights reserved.
//

import UIKit

protocol TPSMainMenuSceneModelBinder:class {
    var __gameViewController:GKGameViewController { get }
}

class TPSMainMenuSceneModel: TPSandBoxSceneModel{
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
        binder.__gameViewController.presentScene(with: .startScene)
    }
    func onBuildItemTap() {
        self.rootSceneModel.mode.accept(.build)
        self.rootSceneModel.binder.present(to: TPSBuildScene())
    }
    func onCaptureItemTap() {
        
    }
    func onShopItemTap() {
        
    }    
}
