//
//  GKBackgroundScene.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/18.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

class GKBackgroundScene: SKScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view?.touchesBegan(touches, with: event)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        view?.touchesMoved(touches, with: event)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view?.touchesEnded(touches, with: event)
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        view?.touchesCancelled(touches, with: event)
    }
}
