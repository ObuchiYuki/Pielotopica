//
//  TPSandBoxSceneUIModel.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/22.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

protocol TPSandBoxSceneUIModelBinder: class {
    var __viewController:UIViewController { get }
    
    func __showItemBar()
    func __hideItemBar()
    
    func __showMainMenu()
    func __hideMainMenu()
}

class TPSandBoxSceneUIModel<Binder: TPSandBoxSceneUIModelBinder> {
    // ========================================================= //
    // MARK: - Properties -
    weak var binder:Binder!
    
    // ========================================================= //
    // MARK: - Handlers -
    
    // MARK: - Main Menu -
    func onMainMenuMenuItemTap() {
        
    }
    func onMainMenuBuildItemTap() {
        binder.__hideMainMenu()
        binder.__showItemBar()
    }
    func onMainMenuCaptureItemTap() {
        presentViewControllerToCapture()
    }
    func onMainMenuShopItemTap() {
        
    }
    
    // MARK: - Item Bar -
    func onBuildBackButtonTap() {
        binder.__showMainMenu()
        binder.__hideItemBar()
    }
    func onBuildPlaceButtonTap() {
        
    }
    func onBuildMoveButtonTap() {
        
    }
    func onBuildDestroyButtonTap() {
        
    }
    
    // ========================================================= //
    // MARK: - Private Methods -
    private func presentViewControllerToCapture() {
        (self.binder.__viewController.presentingViewController as! RouterViewController).route = .capture
        
        self.binder.__viewController.dismiss(animated: false, completion: {})
    }
    
    init(_ binder:Binder) {
        self.binder = binder
    }
    
}
