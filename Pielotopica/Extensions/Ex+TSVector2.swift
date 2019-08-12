//
//  Ex+TSVector.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/13.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation
import CoreGraphics

public extension TSVector2 {
    static func + (right:TSVector2, left:TSVector2) -> TSVector2 {
        
        return TSVector2(right.simd &+ left.simd)
    }
    static func - (left:TSVector2, right:TSVector2) -> TSVector2 {
        
        return TSVector2(right.simd &- left.simd)
    }
    
    static func * (left:TSVector2, right:Int16) -> TSVector2 {
        
        return TSVector2(left.simd &* SIMD(repeating: right))
    }
    
    static func / (left:TSVector2, right:Int16) -> TSVector2 {
        
        return TSVector2(left.simd / SIMD(repeating: right))
    }
    
    static prefix func - (right:TSVector2) -> TSVector2 {
        
        return TSVector2(-right.x16, -right.z16)
    }
}

public extension TSVector2 {
    init(_ point:CGPoint) {
        self.simd = SIMD(Int16(point.x), Int16(point.y))
    }
}

extension TSVector2: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Int16...) {
        self.simd = SIMD(elements[0], elements[1])
        
    }
}

public extension TSVector2 {
    static let zero = TSVector2(0, 0)
    static let unit = TSVector2(1, 1)
}

public extension TSVector2 {
    var vector3:TSVector3 {
        return TSVector3(x16, 0, z16)
    }
}

public extension TSVector2 {
    func applying(_ t:CGAffineTransform) -> TSVector2 {
        let p = CGPoint(x: x, y: z)
        let tp = p.applying(t)
        let r = TSVector2(Int16(tp.x), Int16(tp.y))
        
        return r
    }
}
