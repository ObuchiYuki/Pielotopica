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
    
}

// MARK: - Constructors -
extension TSChunkPoint {
    
    @inline(__always)
    public init(_ x: Int16, _ z:Int16) {
        self.simd = SIMD2(x, z)
    }
}

extension TSChunkPoint {
    
    @inline(__always)
    var vector2: TSVector2 {
        return TSVector2(simd.x * TSChunk.sideWidth, simd.x * TSChunk.sideWidth)
    }
    
    @inline(__always)
    func vector3(y: Int16) -> TSVector3 {
        return TSVector3(simd.x * TSChunk.sideWidth, y, simd.x * TSChunk.sideWidth)
    }
    
    @inline(__always)
    func vector3(y: Int) -> TSVector3 {
        return self.vector3(y: Int16(y))
    }
}

extension TSChunkPoint {
    public static let zero = TSChunkPoint(0, 0)
    public static let unit = TSChunkPoint(1, 1)
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
    public static func += (left: inout TSChunkPoint, right: TSChunkPoint) {
        left = TSChunkPoint(simd: left.simd &+ right.simd)
    }
    
    @inline(__always)
    public static func -= (left: inout TSChunkPoint, right: TSChunkPoint)  {
        left = TSChunkPoint(simd: left.simd & right.simd)
    }
}

extension TSChunkPoint: CustomStringConvertible {
    public var description: String {
        return "TSChunkPoint(x: \(x), y: \(z))"
    }
}
