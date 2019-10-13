//
//  TPSandBoxScene.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/28.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

/// Sandbox画面は複雑なので分割する用です。
protocol TPSandBoxScene: GKSafeScene {
    var __sceneMode: TPSandBoxRootSceneModel.Mode { get }
    var __sceneModel:TPSandBoxSceneModel { get }
    
    func show(from oldScene: TPSandBoxRootSceneModel.Mode?)
    func hide(to newScene: TPSandBoxRootSceneModel.Mode, _ completion: @escaping ()->Void)
}


