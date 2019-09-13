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
    // MARK: - Public Properies -
    
    public typealias SIMD = SIMD3<Int16>
    
    /// simd value of TSVector3
    public var simd:SIMD
    
    // =============================================================== //
    // MARK: - Private Properies -
    
    // =============================================================== //
    // MARK: - Constructors -
    @inline(__always)
    public init(_ simd: SIMD = SIMD.zero) {
        self.simd = simd
    }
    
    @inline(__always)
    public init(_ x:Int, _ y:Int, _ z:Int) {
        self.simd = SIMD(Int16(x), Int16(y), Int16(z))
    }
    
    @inline(__always)
    public init(_ x:Int16, _ y:Int16, _ z:Int16) {
        self.simd = SIMD(x, y, z)
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
        @inline(__always) get{return Int(simd.x)}
        @inline(__always) set{self.simd.x = Int16(newValue)}
    }
    
    @inline(__always)
    /// y component of TSVector3
    public var y:Int {
        @inline(__always) get{return Int(simd.y)}
        @inline(__always) set{self.simd.y = Int16(newValue)}
    }
    /// z component of TSVector3
    @inline(__always)
    public var z:Int {
        @inline(__always) get{return Int(simd.z)}
        @inline(__always) set{self.simd.z = Int16(newValue)}
    }
    
    // ============================ //
    // MARK: - Int16 components
    
    @inline(__always)
    public var x16:Int16 {
        @inline(__always) get{return simd.x}
        @inline(__always) set{simd.x = newValue}
    }
    
    @inline(__always)
    public var y16:Int16 {
        @inline(__always) get{return simd.y}
        @inline(__always) set{simd.y = newValue}
    }
    
    @inline(__always)
    public var z16:Int16 {
        @inline(__always) get{return simd.z}
        @inline(__always) set{simd.z = newValue}
    }
}

// =============================================================== //
// MARK: - Extension for Equatable -

extension TSVector3 :Equatable {
    @inlinable @inline(__always)
    public static func == (left:TSVector3, right:TSVector3) -> Bool {
        return left.simd == right.simd
    }
}

// =============================================================== //
// MARK: - Extension for Hashable -

extension TSVector3 :Hashable {
    @inlinable @inline(__always)
    public func hash(into hasher: inout Hasher) {
        hasher.combine(simd)
    }
}

// =============================================================== //
// MARK: - Extension for Codable -

extension TSVector3: Codable {
    
}

// =============================================================== //
// MARK: - Extension for CustomStringConvertible -

extension TSVector3: CustomStringConvertible {
    @inline(__always)
    public var description: String {
        return "TSVecto3(x: \(x), y: \(y), z: \(z))"
    }
}


