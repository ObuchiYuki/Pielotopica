//
//  Ex+SKNode.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/19.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

extension SKNode {
    /// touchBegan, tapなどのアクションを受け取る必要があるかです。
    @objc var needsHandleReaction:Bool {
        return false
    }
}
