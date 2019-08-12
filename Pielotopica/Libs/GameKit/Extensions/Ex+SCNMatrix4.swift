//
//  Ex+SCNMatrix4.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/04.
//  Copyright © 2019 yuki. All rights reserved.
//

import SceneKit

public extension SCNMatrix4 {
    mutating func translate(_ tx:Float = 0,_ ty:Float = 0, _ tz:Float){
        self = SCNMatrix4Translate(self, tx, ty, tz)
    }
    mutating func scale(by scalar:Float){
        self = SCNMatrix4Scale(self, scalar, scalar, scalar)
    }
    mutating func scale(x:Float = 1, y:Float = 1, z:Float = 1) {
        self = SCNMatrix4Scale(self, x, y, z)
    }
    mutating func rotate(by angle:Float, x:Float=0, y:Float=0, z:Float=0){
        self = SCNMatrix4Rotate(self, angle, x, y, z)
        
    }
}
