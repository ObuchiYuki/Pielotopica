//
//  TSChunkPoint.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/13.
//  Copyright © 2019 yuki. All rights reserved.
//

import simd

// MARK: - TSChunkPoint -
public struct TSChunkPoint {
    public var simd:SIMD2<Int16>
    
}

// MARK: - Properties -
extension TSChunkPoint {
    /// x component of `TSChunkPoint`
    @inline(__always)
    public var x: Int16 { return simd.x }
    
    /// z component of `TSChunkPoint`
    @inline(__always)
    public var z: Int16 { return simd.y }
    
    @inline(__always)
    public var tsVector2: TSVector2 {
        return TSVector2(simd.x * TSChunk.sideWidth, simd.x * TSChunk.sideWidth)
    }
}

// MARK: - Constructors -
extension TSChunkPoint {
    
    @inline(__always)
    public init(_ x: Int16, _ z:Int16) {
        self.simd = SIMD2(x, z)
    }
}

// MARK: - Equatable & Hashable -
extension TSChunkPoint: Equatable {
    @inline(__always)
    public static func == (left: TSChunkPoint, right: TSChunkPoint) -> Bool {
        return left.simd == right.simd
    }
}

extension TSChunkPoint: Hashable {
    @inline(__always)
    public func hash(into hasher: inout Hasher) {
        hasher.combine(simd)
    }
}

// MARK:  - Operator -
extension TSChunkPoint {
    @inline(__always)
    public static func + (left: TSChunkPoint, right: TSChunkPoint) -> TSChunkPoint {
        return TSChunkPoint(simd: left.simd &+ right.simd)
    }
    
    @inline(__always)
    public static func - (left: TSChunkPoint, right: TSChunkPoint) -> TSChunkPoint {
        return TSChunkPoint(simd: left.simd &- right.simd)
    }
    
    @inline(__always)
    public static func * (left: TSChunkPoint, right: TSChunkPoint) -> TSChunkPoint {
        return TSChunkPoint(simd: left.simd &* right.simd)
    }
    
    @inline(__always)
    public static func += (left: inout TSChunkPoint, right: TSChunkPoint) -> TSChunkPoint {
        left = TSChunkPoint(simd: left.simd &+ right.simd)
    }
    
    @inline(__always)
    public static func -= (left: inout TSChunkPoint, right: TSChunkPoint) -> TSChunkPoint {
        left = TSChunkPoint(simd: left.simd & right.simd)
    }
}
