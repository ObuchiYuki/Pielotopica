//
//  Ex+TSVector3.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/03.
//  Copyright © 2019 yuki. All rights reserved.
//

import SceneKit
import simd

// =============================================================== //
// MARK: - Extension For SceneKit -
extension TSVector3 {
    
    /// SCNVector3からTSvector3を初期化します。
    /// TSvector3の元の範囲は、Int.min〜Int.maxの範囲です。
    public init(_ scnVector3:SCNVector3) {
        
        self.simd = SIMD(Int16(scnVector3.x), Int16(scnVector3.y), Int16(scnVector3.z))
        
    }
    
    // Converted TSVector3 to SCNVector3
    public var scnVector3:SCNVector3 {
        return SCNVector3(self.x, self.y, self.z)
    }
    
    /// SIMD vector for SceneKit
    public var scnSIMD:simd_float3 {
        return simd_float3(simd)
        
    }
    
}

// =============================================================== //
// MARK: - Method Extension -
extension TSVector3 {
    public func rotated(x: UInt8, y:UInt8, z:UInt8) -> TSVector3 {
        
    }
}

// =============================================================== //
// MARK: - Opetrators Extension -
extension TSVector3 {
    
    public static func + (left:TSVector3, right:TSVector3) -> TSVector3 {
        return TSVector3(left.simd &+ right.simd)
    }
    public static func - (left:TSVector3, right:TSVector3) -> TSVector3 {
        return TSVector3(left.simd &- right.simd)
    }
    
    public static func * (left:TSVector3, right:Int16) -> TSVector3 {
        return TSVector3(left.simd &* SIMD(repeating: right))
    }
}

extension TSVector3 {
    static public let zero = TSVector3(0, 0, 0)
    
    /// An unit size of TSVector3 which is `(x: 1, y: 1, z: 1)`
    static public let unit = TSVector3(1, 1, 1)
}

extension TSVector3 {
    var vector2:TSVector2 {
        return TSVector2(x16, z16)
    }
}

extension TSVector3:ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Int16...) {
        
        self.simd = SIMD(elements)
    }
}
