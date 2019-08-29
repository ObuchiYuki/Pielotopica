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
    func __present(to scene: TPSandBoxScene, as mode: TPSandBoxRootSceneModel.Mode) -> Bool
}


class TPSandBoxRootSceneModel {
    // 基本的に解放されないので被強参照注意
    
    // ===================================================================================== //
    // MARK: - Properties -
    /// シングルトン (ViewModelのシングルトンって何だよ。自問)
    static let shared = TPSandBoxRootSceneModel()
    
    enum Mode {
        case mainmenu
        case build
        case craft
        
        case battle
    }
    
    /// 現在のSceneのモードです。
    var mode = BehaviorRelay(value: Mode.mainmenu)
    
    /// 現在のシーンモデルです。
    weak var currentSceneModel:TPSandBoxSceneModel!
    
    // ========================================================= //
    // MARK: - Private -
    private weak var binder:TPSandBoxRootSceneModelBinder!
    
    private var sceneModel3D:TPSandBox3DSceneModel { TPSandBox3DSceneModel.initirized! }
    
    // ========================================================= //
    // MARK: - Handlers -
    
    func present(to scene: TPSandBoxScene) {
        let mode = scene.__sceneMode
        
        currentSceneModel = scene.__sceneModel
        let success = self.binder.__present(to: scene, as: mode)
        if success { self.mode.accept(mode) }
        
        self._didSceneChanged(to: mode)
    }
    
    func setBinder(_ binder:TPSandBoxRootSceneModelBinder) {
        self.binder = binder
    }
    
    // ========================================================= //
    // MARK: - Private Methods -
    
    private func _didSceneChanged(to mode: Mode) {
        if mode == .battle {
            sceneModel3D.makeBattleMode()
        }else{
            sceneModel3D.makeNormalMode()
        }
    }
}
