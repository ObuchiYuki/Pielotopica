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
    public init(_ simd: SIMD = SIMD.zero) {
        self.simd = simd
        
    }
    
    public init(_ x:Int, _ y:Int, _ z:Int) {
        self.simd = SIMD(Int16(x), Int16(y), Int16(z))
        
    }
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
    public var x:Int {
        get{return Int(simd.x)}
        set{self.simd.x = Int16(newValue)}
    }
    /// y component of TSVector3
    public var y:Int {
        get{return Int(simd.y)}
        set{self.simd.y = Int16(newValue)}
    }
    /// z component of TSVector3
    public var z:Int {
        get{return Int(simd.z)}
        set{self.simd.z = Int16(newValue)}
    }
    
    // ============================ //
    // MARK: - Int16 components
    
    public var x16:Int16 {
        get{return simd.x}
        set{simd.x = newValue}
    }
    public var y16:Int16 {
        get{return simd.y}
        set{simd.y = newValue}
    }
    public var z16:Int16 {
        get{return simd.z}
        set{simd.z = newValue}
    }
}

// =============================================================== //
// MARK: - Extension for Equatable -

extension TSVector3 :Equatable {
    public static func == (left:TSVector3, right:TSVector3) -> Bool {
        return left.simd == right.simd
    }
}

// =============================================================== //
// MARK: - Extension for Hashable -

extension TSVector3 :Hashable {
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
    public var description: String {
        return "TSVecto3(x: \(x), y: \(y), z: \(z))"
    }
}


