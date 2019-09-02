//
//  Ex+SCNAction.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/04.
//  Copyright © 2019 yuki. All rights reserved.
//

import SceneKit

public extension SCNAction {
    class func cameraZoom(to scale:Double, duration seconds: TimeInterval) -> SCNAction {
        
        var originalScale = -1.0
        
        return SCNAction.customAction(duration: seconds) { node, time in
            guard let camera = node.camera else {return}
            if originalScale < 0 {originalScale = camera.orthographicScale}
            
            let ratio = Double(time) / seconds
            
            camera.orthographicScale = (scale - originalScale) * ratio + originalScale
        }
    }

    func setEase(_ ease:SCNActionTimingMode) -> SCNAction{
        self.timingMode = ease
        return self
    }
}

