//
//  TPGameRootSceneModel.swift
//  Pielotopica
//
//  Created by yuki on 2019/10/13.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

// ======================================================== //
// MARK: - TPGameRootSceneModelBinder -
protocol TPGameRootSceneModelBinder: class {
    func __present(to scene: TPGameScene) -> Bool
}

// ======================================================== //
// MARK: - TPGameRootSceneModel -

/// このクラスは使う前に`TPGameRootScene`から`.initiarize(with: self)`を呼び出される必要があります。
class TPGameRootSceneModel {
    
    // ======================================================== //
    // MARK: - Properties -
    
    /// `TPGameScene`のインスタンスはこのプロパティから現在の
    /// `TPGameRootSceneModel`にアクセスしても良い
    static let shared = TPGameRootSceneModel()
    
    // MARK: - Privates -
    private weak var scene: TPGameRootSceneModelBinder!
    
    // ======================================================== //
    // MARK: - Methods -
    /// 次の`Scene`へ画面遷移します。
    func present(to scene: TPGameScene) {
        self.scene.__present(to: scene)
    }
    
    func initiarize(with scene: TPGameRootSceneModelBinder) {
        self.scene = scene
    }
}
