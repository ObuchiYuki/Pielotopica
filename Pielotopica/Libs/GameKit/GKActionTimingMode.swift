//
//  GKActionTimingMode.swift
//  TPStartScene
//
//  Created by yuki on 2019/07/08.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

public struct GKActionTimingMode {
    let timingFunction:((Float)->(Float))
    
    init(func timingFunction:@escaping (Float)->(Float)) {
        self.timingFunction = timingFunction
    }
}

extension GKActionTimingMode {
    // no easing, no acceleration
    static let linear = GKActionTimingMode{t in t}
    
    // accelerating from zero velocity
    static let easeInQuad = GKActionTimingMode{t in t * t}
    
    // decelerating to zero velocity
    static let easeOutQuad = GKActionTimingMode{t in t*(2-t)}
    
    // acceleration until halfway, then deceleration
    static let easeInOutQuad:GKActionTimingMode = GKActionTimingMode{t in
        if t<0.5{
            return Float(2*t*t)
        }else{
            return Float(-1+(4-2*t)*t)
        }
    }
}
