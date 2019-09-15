//
//  TSVector3.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/02.
//  Copyright © 2019 yuki. All rights reserved.
//

import SceneKit
import simd

/**
 SandBox次元のベクターを提供します。
 SCNVector3との関係は `TSVector3 = SCNVector3`です。
 
 各元は必ず整数値になります。
 各元はInt16の範囲内である必要があります。
 */
public struct TSVector3 {
    // =============================================================== //
    // MARK: - Pubulic Properies -
    
    var x16: Int16
    var y16: Int16
    var z16: Int16
    
    // =============================================================== //
    // MARK: - Constructors -
    
    @inline(__always)
    public init(_ x:Int, _ y:Int, _ z:Int) {
        (x16, y16, z16) = (Int16(x), Int16(y), Int16(z))
    }
    
    @inline(__always)
    public init(_ x:Int16, _ y:Int16, _ z:Int16) {
        (x16, y16, z16) = (x, y, z)
    }
}

// =============================================================== //
// MARK: - Extension for Components Access -

extension TSVector3 {
    // ============================ //
    // MARK: - Int components
    
    /// x component of TSVector3
    @inline(__always)
    public var x:Int {
        @inline(__always) get{return Int(x16)}
        @inline(__always) set{self.x16 = Int16(newValue)}
    }
    
    /// y component of TSVector3
    @inline(__always)
    public var y:Int {
        @inline(__always) get{return Int(y16)}
        @inline(__always) set{self.y16 = Int16(newValue)}
    }
    
    /// z component of TSVector3
    @inline(__always)
    public var z:Int {
        @inline(__always) get{return Int(z16)}
        @inline(__always) set{self.z16 = Int16(newValue)}
    }
    
    // ============================ //
    // MARK: - Int16 components
    
    @inline(__always)
    public var tuple:(Int, Int, Int) {
        return (x, y, z)
    }
    
    @inline(__always)
    public var tuple16:(Int16, Int16, Int16) {
        return (x16, y16, z16)
    }
}


// =============================================================== //
// MARK: - Opetrators Extension -
extension TSVector3 {
    @inline(__always)
    public static func + (left:TSVector3, right:TSVector3) -> TSVector3 {
        return TSVector3(left.x16 + right.x16, left.y16 + right.y16, left.z16 + right.z16)
    }
    
    @inline(__always)
    public static func - (left:TSVector3, right:TSVector3) -> TSVector3 {
        return TSVector3(left.x16 - right.x16, left.y16 - right.y16, left.z16 - right.z16)
    }
    @inline(__always)
    public static func += (left:inout TSVector3, right:TSVector3) {
        left = left + right
    }
    @inline(__always)
    public static func -= (left:inout TSVector3, right:TSVector3) {
        left = left - right
    }
    @inline(__always)
    public static func * (left:TSVector3, right:Int16) -> TSVector3 {
        return TSVector3(left.x16 * right, left.y16 * right, left.z16 * right)
    }
}

extension TSVector3 {
    static public let zero = TSVector3(0, 0, 0)
    
    /// An unit size of TSVector3 which is `(x: 1, y: 1, z: 1)`
    static public let unit = TSVector3(1, 1, 1)
}

extension TSVector3 {
    @inline(__always)
    var vector2:TSVector2 {
        return TSVector2(x16, z16)
    }
    
    @inline(__always)
    var hasNegative:Bool {
        return x16 < 0 || y16 < 0 || z16 < 0
    }
    
    @inline(__always)
    var positive: TSVector3 {
        return TSVector3(abs(x16), abs(y16), abs(z16))
    }
}

extension TSVector3: ExpressibleByArrayLiteral {
    @inline(__always)
    public init(arrayLiteral elements: Int16...) {
        assert(elements.count == 3, "Initirization of TSVector3 require '3' elements.")
        
        self.x16 = elements[0]
        self.y16 = elements[1]
        self.z16 = elements[2]
    }
}


// =============================================================== //
// MARK: - Extension for Equatable -

extension TSVector3 :Equatable & Hashable {}

// =============================================================== //
// MARK: - Extension for Codable -

extension TSVector3: Codable {}

// =============================================================== //
// MARK: - Extension for CustomStringConvertible -

extension TSVector3: CustomStringConvertible {
    @inline(__always)
    public var description: String {
        return "TSVecto3(x: \(x), y: \(y), z: \(z))"
    }
}

func abs(_ vector3: TSVector3) -> CGFloat {
    return sqrt(CGFloat(vector3.x16 * vector3.x16 + vector3.y16 * vector3.y16 + vector3.z16 * vector3.z16))
}

