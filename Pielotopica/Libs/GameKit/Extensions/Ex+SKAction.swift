//
//  Ex+SKAction.swift
//  TPStartScene
//
//  Created by yuki on 2019/07/07.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

extension SKAction {
    
    class func numberChanging(
        from fromValue:Int, to toValue: Int, prefix:String = "", postfix:String = "", withDuration duration:TimeInterval
    ) -> SKAction {
        
        let rcount = Double(toValue - fromValue) / duration
        
        return SKAction.customAction(withDuration: duration){ node, time in
            guard let label = node as? SKLabelNode else {return}
            
            label.text = prefix + String(Int(rcount * Double(time)) + fromValue) + postfix
        }
    }
    
    class func typewriter(_ string:String, withDuration duration:TimeInterval) -> SKAction {
        let perDuration = CGFloat(duration / TimeInterval(string.count))
        
        return SKAction.customAction(withDuration: duration){ node, time in
            guard let label = node as? SKLabelNode else {return}
            
            let offset = Int(round(time / perDuration))
            let range = string.index(string.startIndex, offsetBy: offset)
            
            label.text = String(string.prefix(upTo: range))
            
        }
    }
    
    class func typewriter(_ string:String, withPerDuration duration:TimeInterval) -> SKAction {
        SKAction.typewriter(string, withDuration: Double(string.count) * duration)
    }
    
    func setEase(_ mode:SKActionTimingMode) -> SKAction {
        self.timingMode = mode
        
        return self
    }
    
    func setEase(func function:GKActionTimingMode) -> SKAction {
        self.timingFunction = function.timingFunction
        
        return self
    }
}
