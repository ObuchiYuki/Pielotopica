//
//  Ex+SCNVector3.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/04.
//  Copyright © 2019 yuki. All rights reserved.
//

import SceneKit

// ============================================================================== //
// MARK: - Default value of SCNVector3 -
public extension SCNVector3 {
    // Zero value of SCNVector3
    static let zero = SCNVector3(0, 0, 0)
    
    // Unit value of SCNVector3
    static let unit = SCNVector3(1, 1, 1)
}

// ============================================================================== //
// MARK: - SCNVector3 Operators -
public extension SCNVector3 {
    static func - (left:SCNVector3, right:SCNVector3) -> SCNVector3 {
        return SCNVector3(left.x - right.x, left.y - right.y, left.z - right.z)
    }
    
    static func + (left:SCNVector3, right:SCNVector3) -> SCNVector3 {
        return SCNVector3(left.x + right.x, left.y + right.y, left.z + right.z)
    }
    
    static func * (left:SCNVector3, right:SCNVector3) -> SCNVector3 {
        return SCNVector3(left.x * right.x, left.y * right.y, left.z * right.z)
    }
    
    static func / (left:SCNVector3, right:SCNVector3) -> SCNVector3 {
        return SCNVector3(left.x / right.x, left.y / right.y, left.z / right.z)
    }
    
    static func * <T: BinaryInteger>(left:SCNVector3, right:T) -> SCNVector3 {
        let fr = Float(right)
        return SCNVector3(left.x * fr, left.y * fr, left.z * fr)
    }
    
    static func / <T: BinaryInteger>(left:SCNVector3, right:T) -> SCNVector3 {
        let fr = Float(right)
        return SCNVector3(left.x / fr, left.y / fr, left.z / fr)
    }
    
    static prefix func - (left:SCNVector3) -> SCNVector3 {
        return SCNVector3(-left.x, -left.y, -left.z)
    }
    
    static prefix func + (left:SCNVector3) -> SCNVector3 {
        return left
    }
}

// ============================================================================== //
// MARK: - Custom Constructor -
extension SCNVector3: ExpressibleByArrayLiteral {
    
    public init(arrayLiteral elements: Float...) {
        assert(elements.count == 3)
        self.init(x: elements[0], y: elements[1], z: elements[2])
    }
}
