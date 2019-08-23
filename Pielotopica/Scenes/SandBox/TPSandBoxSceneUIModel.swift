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
    
    func __setItemBarSelectionState(to state: TPItemBarSelectionState)
}

enum TPItemBarSelectionState {
    case none
    case place
    case move
    case destory
}

class TPSandBoxSceneUIModel<Binder: TPSandBoxSceneUIModelBinder> {
    // ========================================================= //
    // MARK: - Properties -
    private weak var binder:Binder!
    
    private enum Mode {
        case mainmenu
        
        case buildNone
        case buildPlace
        case buildMove
        case buildDestory
    }
    
    private var mode:Mode = .mainmenu { didSet {_modeDidChanged()} }
    private var sceneModel:TPSandboxSceneModel { return TPSandboxSceneModel.initirized! }
    
    // ========================================================= //
    // MARK: - Handlers -
    
    // MARK: - Main Menu -
    func onMainMenuMenuItemTap() {
        
    }
    func onMainMenuBuildItemTap() {
        binder.__hideMainMenu()
        binder.__showItemBar()
        
        self.mode = .buildNone
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
        
        self.mode = .mainmenu
    }
    func onBuildPlaceButtonTap() {
        self.mode = .buildPlace
    }
    func onBuildMoveButtonTap() {
        self.mode = .buildMove
    }
    func onBuildDestroyButtonTap() {
        self.mode = .buildDestory
    }
    
    // ========================================================= //
    // MARK: - Private Methods -
    private func presentViewControllerToCapture() {
        (self.binder.__viewController.presentingViewController as! RouterViewController).route = .capture
        
        self.binder.__viewController.dismiss(animated: false, completion: {})
    }
    private func _modeDidChanged() {
        sceneModel.canEnterBlockPlaingMode = mode == .buildPlace
        
        let itemBarState = _convertMode(self.mode)
        
        binder.__setItemBarSelectionState(to: itemBarState)
    }
    
    private func _convertMode(_ mode: Mode) -> TPItemBarSelectionState {
        switch mode {
        case .mainmenu , .buildNone: return  .none
        case .buildMove: return .move
        case .buildPlace:return .place
        case .buildDestory:return .destory
        }
    }
    
    init(_ binder:Binder) {
        self.binder = binder
    }
    
}
