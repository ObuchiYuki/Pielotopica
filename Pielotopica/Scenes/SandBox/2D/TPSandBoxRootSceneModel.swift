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
    func present(to scene: TPSandBoxScene, as mode: TPSandBoxRootSceneModel.Mode) -> Bool 
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
    static let shared = TPSandBoxRootSceneModel()
    
    // ========================================================= //
    // MARK: - Private -
    private weak var binder:TPSandBoxRootSceneModelBinder!
    
    // ========================================================= //
    // MARK: - Handlers -
    
    func present(to scene: TPSandBoxScene, as mode:TPSandBoxRootSceneModel.Mode) {
        currentSceneModel = scene.__sceneModel
        let success = self.binder.present(to: scene, as: mode)
        if success { self.mode.accept(mode) }
    }
    func setBinder(_ binder:TPSandBoxRootSceneModelBinder) {
        self.binder = binder
    }
}
