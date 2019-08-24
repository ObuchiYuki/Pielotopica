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
        
        let x = scnVector3.x.rounded(.toNearestOrAwayFromZero)
        let y = scnVector3.y.rounded(.toNearestOrAwayFromZero)
        let z = scnVector3.z.rounded(.toNearestOrAwayFromZero)
        
        self.simd = SIMD(Int16(x), Int16(y), Int16(z))
        
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
    /**
    
          (screen-back)                -z
           _ _ _ _ _                   |
           |       |              -x -+y-- +x
    (left) | (top) | (right)           |
           |       |                   +z
           - - - - -
         (screen-front)
    
    rotate(x: 1, y: 0, z: 0)
    
          -y
          |
     -x  -z  +x
          |
          +y
    
    +方向から見て反時計回りに (90˚ x 入力 )回転

     整数オンリーなので行列は使わず高速化
     もし、ある次元にのみ回転させる場合は
     rotated(x:), rotated(y:), rotated(z:) を用いてください。
    */
    public func rotated(x rx:UInt8, y ry:UInt8, z rz:UInt8) -> TSVector3 {
        return rotated(x: rx).rotated(y: ry).rotated(z: rz)
    }
    
    public func rotated(x rx:UInt8) -> TSVector3 {
        switch rx % 4 {
        case 0: return self
        case 1: return TSVector3( x16, -z16,  y16)
        case 2: return TSVector3( x16, -y16, -z16)
        case 3: return TSVector3( x16,  z16, -y16)
        default: fatalError()
        }
    }
    public func rotated(y ry:UInt8) -> TSVector3 {
        switch ry % 4 {
        case 0: return self
        case 1: return TSVector3(-z16,  y16,  x16)
        case 2: return TSVector3(-x16,  y16, -z16)
        case 3: return TSVector3( z16,  y16, -x16)
        default: fatalError()
        }
    }
    public func rotated(z rz:UInt8) -> TSVector3 {
        switch rz % 4 {
        case 0: return self
        case 1: return TSVector3(-y16,  x16,  z16)
        case 2: return TSVector3(-x16, -y16,  z16)
        case 3: return TSVector3( y16, -x16,  z16)
        default: fatalError()
        }
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
