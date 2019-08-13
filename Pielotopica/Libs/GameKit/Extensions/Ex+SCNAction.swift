//
//  Ex+SCNAction.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/04.
//  Copyright © 2019 yuki. All rights reserved.
//

import SceneKit

public extension SCNAction {
    func setEase(_ ease:SCNActionTimingMode) -> SCNAction{
        self.timingMode = ease
        return self
    }
}

