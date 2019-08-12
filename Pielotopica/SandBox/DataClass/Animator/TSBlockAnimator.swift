//
//  TSBlockAnimator.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/19.
//  Copyright © 2019 yuki. All rights reserved.
//

import SceneKit
import RxCocoa
import RxSwift

// =============================================================== //
// MARK: - TSBlockAnimator -

/**
 */
class TSBlockAnimator {
    // =============================================================== //
    // MARK: - Properties -
    
    // =============================================================== //
    // MARK: - Private Properties -
    
    // =============================================================== //
    // MARK: - Methods -
    
    // =============================================================== //
    // MARK: - Constructor -
    
    // =============================================================== //
    // MARK: - Private Methods -
    private static func generateParticles() -> SCNParticleSystem {
        let particle = SCNParticleSystem(named: "TSBlockPlaceAnimation", inDirectory: nil)!
        
        return particle
    }
    static func generateBlockPlaceAnimation(for node:SCNNode) -> SCNAction {
        let a1 = SCNAction.move(by: [0, 0.7, 0], duration: 0.15).setEase(.easeInEaseOut)
        let a2 = SCNAction.move(by: [0, -0.7, 0], duration: 0.1).setEase(.easeInEaseOut)
        
        let aa1 = SCNAction.customAction(duration: 0.2, action: {node, t in
            let dt = t / 0.2
            let t:Float = Float(1 + (dt * 0.1))
            node.simdScale = simd_float3(t, 1/t, t)
        })
        let aa2 = SCNAction.move(by: [0, -0.05, 0], duration: 0.2)
        let a3 = SCNAction.group([aa1, aa2]).setEase(.easeInEaseOut)
        
        let ps = self.generateParticles()
        let ab1 = SCNAction.customAction(duration: 0.15, action: {node, t in
            let dt = t / 0.2
            let t:Float = Float(1.1 - (dt * 0.1))
            node.simdScale = simd_float3(t, 1/t, t)
        })
        let ab2 = SCNAction.move(by: [0, 0.05, 0], duration: 0.15)
        let ab3 = SCNAction.run{node in
            node.addParticleSystem(ps)
        }
        let a4 = SCNAction.group([ab1, ab2, ab3])
        let a5 = SCNAction.wait(duration: 0.01)
        
        let a6 = SCNAction.run{node in
            ps.birthRate = 0
        }
        
        let ar = SCNAction.sequence([a1, a2, a3, a4, a5, a6])
        
        return ar
    }
}
