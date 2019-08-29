//
//  TPSBuildSceneModel.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/28.
//  Copyright © 2019 yuki. All rights reserved.
//

import RxCocoa
import RxSwift

protocol TPSBuildSceneModelBinder: class {
    func __setItemBarSelectionState(to mode:TPSBuildSceneModel.Mode)
    func __setBuildSideMenuMode(to mode:TPSBuildSceneModel.Mode)
}

class TPSBuildSceneModel: TPSandBoxSceneModel {
    
    enum Mode {
        case place
        case move
        case destory
    }
    
    // ===================================================================== //
    // MARK: - Properties -
    var mode = BehaviorRelay(value: Mode.place) 
    
    private weak var binder:TPSBuildSceneModelBinder!
    private let bag = DisposeBag()
    
    private var sceneModel3D:TPSandBox3DSceneModel {
        return TPSandBox3DSceneModel.initirized!
    }
    
    // ===================================================================== //
    // MARK: - Constructor -
    init(_ binder:TPSBuildSceneModelBinder) {
        super.init()
        self.binder = binder
        
        self.mode.subscribe{[weak self] event in
            event.element.map{self?._modeDidChanged(to: $0)}
            
        }.disposed(by: bag)
    }
    
    // ===================================================================== //
    // MARK: - Handler -
    
    func onBackButtonTap() {
        self.rootSceneModel.present(to: TPSMainMenuScene(), as: .mainmenu)
    }
    func onPlaceButtonTap() {
        self.mode.accept(.place)
    }
    func onMoveButtonTap() {
        self.mode.accept(.move)
    }
    func onDestoryButtonTap() {
        self.mode.accept(.destory)
    }
    func onMoreButtonTap() {
        self.rootSceneModel.present(to: TPSCraftScene(), as: .craft)
    }
    func onRotateButtonTap() {
        assert(sceneModel3D.blockEditHelper != nil)
        sceneModel3D.blockEditHelper?.rotateBlock()    
    }
    
    // ===================================================================== //
    // MARK: - Private -
    private func _modeDidChanged(to mode: Mode) {
        
        binder.__setItemBarSelectionState(to: mode)
        binder.__setBuildSideMenuMode(to: mode)
    }
    
}
