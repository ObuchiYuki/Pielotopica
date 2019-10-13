//
//  TPGameScene.swift
//  Pielotopica
//
//  Created by yuki on 2019/10/13.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

protocol TPGameScene: GKSafeScene {
    func show(from oldScene: TPGameScene?)
    func hide(to newScene: TPGameScene, _ completion: @escaping ()->Void?)
}
