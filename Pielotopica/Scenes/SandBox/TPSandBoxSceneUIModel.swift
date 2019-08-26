//
//  TPSandBoxSceneUIModel.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/22.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit
import RxSwift
import RxCocoa

protocol TPSandBoxSceneUIModelBinder: class {
    var __viewController:UIViewController { get }
    
    func __showItemBar()
    func __hideItemBar()
    
    func __showMainMenu()
    func __hideMainMenu()
    
    func __setItemBarSelectionState(to state: TPItemBarSelectionState)
    func __setBuildSideMenuMode(to mode:TPItemBarSelectionState)
}

enum TPItemBarSelectionState {
    case none
    case place
    case move
    case destory
}

class TPSandBoxSceneUIModel {
    // ========================================================= //
    // MARK: - Properties -
    private weak var binder:TPSandBoxSceneUIModelBinder!
    
    enum Mode {
        case mainmenu
        
        case buildPlace
        case buildMove
        case buildDestory
    }
    
    var mode = BehaviorRelay(value: Mode.mainmenu)
    var sceneModel:TPSandboxSceneModel { return TPSandboxSceneModel.initirized! }
    
    static weak var initirized:TPSandBoxSceneUIModel?
    
    let bag = DisposeBag()
    // ========================================================= //
    // MARK: - Handlers -
    
    // MARK: - Main Menu -
    func onMainMenuMenuItemTap() {
        
    }
    func onMainMenuBuildItemTap() {
        binder.__hideMainMenu()
        binder.__showItemBar()
        
        self.mode.accept(.buildPlace)
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
        
        self.mode.accept(.mainmenu)
    }
    func onBuildPlaceButtonTap() {
        self.mode.accept(.buildPlace)
    }
    func onBuildMoveButtonTap() {
        self.mode.accept(.buildMove)
    }
    func onBuildDestroyButtonTap() {
        self.mode.accept(.buildDestory)
    }
    
    func onSideMenuRotateButtonTap() {
        assert(sceneModel.blockEditHelper != nil)
        sceneModel.blockEditHelper?.rotateBlock()
    }
    
    // ========================================================= //
    // MARK: - Private Methods -
    private func _modeDidChanged(to value: Mode) {
        let itemBarState = _convertMode(value)
        
        binder.__setItemBarSelectionState(to: itemBarState)
        binder.__setBuildSideMenuMode(to: itemBarState)
    }
    
    private func presentViewControllerToCapture() {
        (self.binder.__viewController.presentingViewController as! TPRouterViewController).route = .capture
        
        self.binder.__viewController.dismiss(animated: false, completion: {})
    }
    
    private func _convertMode(_ mode: Mode) -> TPItemBarSelectionState {
        switch mode {
        case .mainmenu: return  .none
        case .buildMove: return .move
        case .buildPlace:return .place
        case .buildDestory:return .destory
        }
    }
    
    init(_ binder:TPSandBoxSceneUIModelBinder) {
        self.binder = binder
        
        self.mode.subscribe{[weak self] event in
            event.element.map{self?._modeDidChanged(to: $0)}
        }.disposed(by: bag)
        TPSandBoxSceneUIModel.initirized = self
    }
    
}
