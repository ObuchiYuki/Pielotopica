//
//  TSModelRotator.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/01.
//  Copyright © 2019 yuki. All rights reserved.
//

import SceneKit

class TSModelRotator {
    static let shared = TSModelRotator()
    /// 中心（奇数の場合は自動調整）周りに rotation x 90度 反時計回り
    func createNodeRotationAnimation(blockSize: TSVector3, rotation ry: Int) -> SCNAction {
        let v1 = _rotateVector(SCNVector3(Double(blockSize.x) / 2, 0, Double(blockSize.z) / 2), rotation: ry)
            
        let (x, z) = (v1.x, v1.z)
        let (X, Z) = (z, -x)
        let (dx, dz) = (x - X, z - Z)
        
        let a1 = SCNAction.move(by: SCNVector3(dx, 0, dz), duration: 0.1)
        let a2 = SCNAction.rotateBy(x: 0, y: .pi/2, z: 0, duration: 0.1)
        
        return SCNAction.group([a1, a2]).setEase(.easeInEaseOut)
    }
    func calcurateAnchorPoint(blockSize: TSVector3, initial: TSVector3, for rotation: TSBlockRotation) -> TSVector3 {
        var position = initial
        
        for i in 0..<rotation.rotation {
            position += calcurateAnchorPointDeltaMovement(blockSize: blockSize, for: i)
        }
        
        return position
    }
    /// ある回転に対する部分移動を計算
    func calcurateAnchorPointDeltaMovement(blockSize: TSVector3, for rotation:Int) -> TSVector3 {
        let v1 = _rotateVector(SCNVector3(Double(blockSize.x) / 2 - 0.5, 0, Double(blockSize.z) / 2 - 0.5), rotation: rotation)
            
        let (x, z) = (v1.x, v1.z)
        let (X, Z) = (z, -x)
        let (dx, dz) = (x - X, z - Z)
        
        return TSVector3(Int16(dx), 0, Int16(dz))
    }
    
    private func _rotateVector(_ vector:SCNVector3, rotation ry:Int) -> SCNVector3 {
        switch ry % 4 {
        case 0: return vector
        case 1: return SCNVector3( vector.z,  vector.y, -vector.x)
        case 2: return SCNVector3(-vector.x,  vector.y, -vector.z)
        case 3: return SCNVector3(-vector.z,  vector.y,  vector.x)
        default: fatalError()
        }
    }
}
