//
//  TPSandBoxRootSceneModel.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/22.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit
import RxSwift
import RxCocoa

protocol TPSandBoxRootSceneModelBinder : class{
    func present(to scene: TPSandBoxScene)
}

class TPSandBoxRootSceneModel {
    // ===================================================================================== //
    // MARK: - Properties -
    enum Mode {
        case mainmenu
        case build
        case craft
    }
    var mode = BehaviorRelay(value: Mode.mainmenu)
    var currentSceneModel:TPSandBoxSceneModel!
    weak var binder:TPSandBoxRootSceneModelBinder!
    
    static let shared = TPSandBoxRootSceneModel()
    
    // ===================================================================================== //
    // MARK: - Private Properties -
    
    private var sceneModel:TPSandBox3DSceneModel {
        return TPSandBox3DSceneModel.initirized!
    }
    
    private let bag = DisposeBag()
    
    // ========================================================= //
    // MARK: - Handlers -
    func onSceneChanged(to scene: TPSandBoxScene) {
        currentSceneModel = scene.__sceneModel
    }
    
    
    
    func onCraftMoreItemSelctedIndexChange(to value:Int) {
        let item = TSItemManager.shared.getCreatableItems().at(value) ?? .none
        
        //binder.__changeCraftMenu(with: item)
        
        if item == .none {return}
        
        if let existingIndex = TSItemBarInventory.itembarShared.itemStacks.value.firstIndex(where: {$0.item == item}) {
            //binder.__placeItemBar(with: .none, at: existingIndex)
        }
        
        guard let itemStack = TSInventory.shared.itemStacks.value.first(where: {$0.item == item})
            else {return}

        //binder.__placeItemBar(with: itemStack, at: binder.__itemBarSelectedIndex)
        
    }
    
    // MARK: - Main Menu -
    func onMainMenuMenuItemTap() {
        //
    }
    
    func onMainMenuBuildItemTap() {
        //binder.__hideMainMenu()
        //binder.__showItemBar()
        
        //self.mode.accept(.buildPlace)
    }
    func onMainMenuCaptureItemTap() {
        presentViewControllerToCapture()
    }
    func onMainMenuShopItemTap() {
        
    }
    
    // MARK: - Item Bar -
    func onBuildBackButtonTap() {
        if mode.value == .craft {
            //binder.__showItemBarDrops()
            //binder.__hideOverlayScene()
            
            self.mode.accept(.mainmenu)
        } else {
            //binder.__showMainMenu()
            //binder.__hideItemBar()
            
            self.mode.accept(.mainmenu)
        }
    }
    func onBuildPlaceButtonTap() {
        //self.mode.accept(.buildPlace)
    }
    func onBuildMoveButtonTap() {
        //self.mode.accept(.buildMove)
    }
    func onBuildDestroyButtonTap() {
        //self.mode.accept(.buildDestory)
    }
    
    func onBuildMoreButtonTap () {
        self.mode.accept(.craft)
        
        //self.binder.__hideItemBarDrops()
        //self.binder.__showCraftScene()
    }
    
    func onSideMenuRotateButtonTap() {
        assert(sceneModel.blockEditHelper != nil)
        sceneModel.blockEditHelper?.rotateBlock()
    }
    
    func onOverlayTap() {
        onBuildBackButtonTap()
    }
    
    // ========================================================= //
    // MARK: - Private Methods -
    private func _modeDidChanged(to value: Mode) {
        //let itemBarState = _convertMode(value)
        
        //binder.__setItemBarSelectionState(to: itemBarState)
        //binder.__setBuildSideMenuMode(to: itemBarState)
    }
    
    private func presentViewControllerToCapture() {
        //(self.binder.__gameViewController.presentingViewController as! TPRouterViewController).route = .capture
        
        //self.binder.__gameViewController.dismiss(animated: false, completion: {})
    }
    
    //private func _convertMode(_ mode: Mode) -> TPItemBarSelectionState {
        //switch mode {
        //case .mainmenu: return  .none
        //case .buildMove: return .move
        //case .buildPlace:return .place
        //case .buildDestory:return .destory
        //case .craft: return .none
        //}
    //}
    
    init() {
      //  self.binder = binder
        
        self.mode.subscribe{[weak self] event in
            event.element.map{self?._modeDidChanged(to: $0)}
        }.disposed(by: bag)
    }
    
}
