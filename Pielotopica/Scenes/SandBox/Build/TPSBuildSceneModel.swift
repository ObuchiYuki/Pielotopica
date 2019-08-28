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
    
    // ===================================================================== //
    // MARK: - Constructor -
    init(_ binder:TPSBuildSceneModelBinder) {
        self.binder = binder
    }
    
    // ===================================================================== //
    // MARK: - Handler -
    
    func onBackButtonTap() {
        self.rootSceneModel.present(to: TPSMainMenuScene(), as: .mainmenu)
    }
    func onPlaceButtonTap() {
        
    }
    func onMoveButtonTap() {
        
    }
    func onDestoryButtonTap() {
        
    }
    func onMoreButtonTap() {
        
    }
    func onRotateButtonTap() {
        
    }
}
