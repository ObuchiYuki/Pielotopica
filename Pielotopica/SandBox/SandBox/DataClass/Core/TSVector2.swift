//
//  TSVector2.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/13.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation
import simd

// =============================================================== //
// MARK: - TSVector2 -

/**
 箱庭場における平面を表します。
 TSVector3を(x, z)平面に射影したものです。
 TSVector3との関係は `TSVector2(x, z) = TSVector3(x, C, z) (C: 任意の定数)`です。
 
 各元は必ず整数値になります。
 各元はInt16の範囲内である必要があります。
 */
public struct TSVector2 {
    // =============================================================== //
    // MARK: - Properties -
    public typealias SIMD = SIMD2<Int16>
    
    public var simd:SIMD
    // =============================================================== //
    // MARK: - Constructor -
    @inline(__always)
    init(_ simd:SIMD = SIMD.zero) {
        self.simd = simd
    }
}

// =============================================================== //
// MARK: - Extension for Components Access -

extension TSVector2 {
    
    /// X component of TSVector2
    
    @inlinable
    @inline(__always)
    public var x:Int {
        @inlinable @inline(__always) get {return Int(simd.x)}
        @inlinable @inline(__always) set {simd.x = Int16(newValue)}
    }
    
    /// Z component of TSVector2
    @inline(__always)
    public var z:Int {
        @inline(__always) get {return Int(simd.y)}
        @inline(__always) set {simd.y = Int16(newValue)}
    }
    
    /// X component of TSVector2 in Int16
    @inline(__always)
    public var x16:Int16 {
        @inline(__always) get {return simd.x}
        @inline(__always) set {simd.x = newValue}
    }
    
    /// Z component of TSVector2 in Int16
    @inline(__always)
    public var z16:Int16 {
        @inline(__always) get {return simd.y}
        @inline(__always) set {simd.y = newValue}
    }
    
    /// Initirize TSVector2 with Int values
    @inline(__always)
    init(_ x:Int,_ z:Int) {
        self.simd = SIMD(Int16(x), Int16(z))
        
    }
    
    /// Initirize TSVector2 with Int16 values
    @inline(__always)
    public init(_ x16:Int16, _ z16:Int16) {
        self.simd = SIMD(x16, z16)
    }
}

extension TSVector2:Equatable {
    @inline(__always)
    public static func == (left:TSVector2, right:TSVector2) -> Bool{
        return left.simd == right.simd
    }
}

extension TSVector2:Hashable {
    @inline(__always)
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.simd)
    }
}

extension TSVector2: CustomStringConvertible {
    @inline(__always)
    public var description: String {
        return "TSVector2(x: \(x), z: \(z))"
    }
}

