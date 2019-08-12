//
//  TPDebug.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/12.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation
import SceneKit

#if DEBUG
public extension TSBlock {
    func illuminantRed(at point:TSVector3) {
        guard let ownNode = getOwnNode(at: point) else {fatalError("Cannot Idetify own node at \(point)")}
        
        let a1 = SCNAction.run{node in
            node.tsMaterial?.selfIllumination.contents = UIColor.red
        }
        let a2 = SCNAction.run{node in
            node.tsMaterial?.selfIllumination.contents = UIColor.black
        }
        let ar = SCNAction.sequence([a1, SCNAction.wait(duration: 1), a2])
        
        ownNode.runAction(ar)
    }
}

#endif
