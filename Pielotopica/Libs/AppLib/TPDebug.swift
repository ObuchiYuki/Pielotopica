//
//  TPDebug.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/12.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation
import SceneKit

/// デバッグ次のみ有効

func debug(_ item: Any...) {
    #if DEBUG
    
    print(item)
    
    #endif
}

#if DEBUG

func measure<T>(_ block: ()->T ) -> T {
    #if DEBUG
    debug("Start Mesurement")
    let start = Date()

    let returns = block()
    debug(Date().timeIntervalSince(start))
    return returns
    
    #else
    return block()
    #endif
    
}



public extension SCNNode {
    func illuminantRed() {
        
        let a1 = SCNAction.run{ node in
            node.geometry!.materials.forEach{ $0.selfIllumination.contents = UIColor.red }
        }
        let a2 = SCNAction.run{ node in
            node.geometry!.materials.forEach{ $0.selfIllumination.contents = UIColor.black }
        }
        let ar = SCNAction.sequence([a1, SCNAction.wait(duration: 1), a2])
        
        self.runAction(ar)
    }
}
public extension TSBlock {
    func illuminantRed(at point:TSVector3) {
        guard let ownNode = getOwnNode(at: point) else {fatalError("Cannot Idetify own node at \(point)")}
        
        ownNode.illuminantRed()
    }
}

/// 普通にメモリリークするので個数は常識的範囲でよろしく
extension TPSandboxSceneController {
    
    static var samples = [TSVector3: SCNNode]()
    static weak var _debug:TPSandboxSceneController!
    
    static func removeSample(at point:TSVector3) {
        guard let sample = samples[point] else {
            debugPrint("There is no node at", point)
            return
        }
        
        sample.removeFromParentNode()
    }
    
    static func addSample(at point:TSVector3, color: UIColor = .white, alpha:CGFloat = 1) {
        let _debugAnchorNode = SCNNode()
        _debugAnchorNode.position = point.scnVector3 + [0.5, 0.5, 0.5]
        let box = SCNBox(width: 0.8, height: 0.8, length: 0.8, chamferRadius: 0.1)
        box.firstMaterial?.diffuse.contents = color
        box.firstMaterial?.transparencyMode = .singleLayer
        box.firstMaterial?.transparency = alpha
        
        _debugAnchorNode.geometry = box
        
        samples[point] = _debugAnchorNode
        
        _debug.scene.rootNode.addChildNode(_debugAnchorNode)
    }
}

#endif
