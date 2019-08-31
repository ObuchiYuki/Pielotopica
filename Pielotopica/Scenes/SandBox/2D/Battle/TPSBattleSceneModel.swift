//
//  File.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/29.
//  Copyright © 2019 yuki. All rights reserved.
//

import RxSwift
import RxCocoa

protocol TPSBattleSceneModelBinder: class {
    func __showAlert(with alert:TPAlert)
    func __setItemBarSelectionState(to mode:TPSBuildSceneModel.Mode)
    func __setBuildSideMenuMode(to mode:TPSBuildSceneModel.Mode)
}

class TPSBattleSceneModel: TPSandBoxSceneModel {
    typealias Mode = TPSBuildSceneModel.Mode
    // ===================================================================== //
    // MARK: - Properties -
    var mode = BehaviorRelay(value: Mode.place)
    
    private weak var binder:TPSBattleSceneModelBinder!
    private let bag = DisposeBag()
    
    private var sceneModel3D:TPSandBox3DSceneModel {
        return TPSandBox3DSceneModel.initirized!
    }
    
    // ===================================================================== //
    // MARK: - Handler -
    
    func onBackButtonTap() {
        let alert = TPAlert(theme: .dark, text: "戦闘を始める前に戻ります。")
        
        alert.setAction1(TPAlertAction(texture: "TP_alertbutton_back_red") {[weak self] in
            self?.rootSceneModel.present(to: TPSMainMenuScene())
            alert.hide()
        })
        
        alert.setAction2(TPAlertAction(texture: "TP_alertbutton_cancel") {
            alert.hide()
        })
        
        binder.__showAlert(with: alert)
        
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
        self.rootSceneModel.present(to: TPSCraftScene())
    }
    func onRotateButtonTap() {
        assert(sceneModel3D.blockEditHelper != nil)
        sceneModel3D.blockEditHelper?.rotateBlock()
    }
    
    init(_ binder:TPSBattleSceneModelBinder) {
        super.init()
        self.binder = binder
        
        self.mode.subscribe{[unowned self] event in
            event.element.map{self._modeDidChanged(to: $0)}
            
        }.disposed(by: bag)
    }
    
    // ===================================================================== //
       // MARK: - Private -
       private func _modeDidChanged(to mode: Mode) {
           
           binder.__setItemBarSelectionState(to: mode)
           binder.__setBuildSideMenuMode(to: mode)
       }
}
