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
        self.rootSceneModel.present(to: TPSBuildScene())
    }
    func onCaptureItemTap() {
        self.presentViewControllerToCapture()
    }
    func onShopItemTap() {
        self.rootSceneModel.present(to: TPSBattleScene())
    }
    
    // ===================================================================== //
    // MARK: - Private -
    private func presentViewControllerToCapture() {
        (self.binder.__gameViewController.presentingViewController as! TPRouterViewController).route = .capture
        
        self.binder.__gameViewController.dismiss(animated: false, completion: {})
    }
}
