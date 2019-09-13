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
    // 
    @inlinable
    @inline(__always)
    public var x: Int16 { return simd.x }
    
    @inlinable
    @inline(__always)
    public var z: Int16 { return simd.y }
    
    @inlinable
    @inline(__always)
    public var tsVector2: TSVector2 {
        TSVector2(simd.x * TSChunk.sideWidth, simd.x * TSChunk.sideWidth)
    }
    
    
}

// MARK: - Constructors -
extension TSChunkPoint {
    @inlinable @inline(__always)
    public init(_ x: Int16, _ z:Int16) {
        self.simd = SIMD2(x, z)
    }
}
