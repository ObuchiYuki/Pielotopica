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
    func show()
    func hide(_ completion: @escaping ()->Void)
}


