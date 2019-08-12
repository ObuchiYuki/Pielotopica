//
//  Ex+SceneKit.swift
//  3DAppSample
//
//  Created by yuki on 2019/05/09.
//  Copyright © 2019 yuki. All rights reserved.
//

import SceneKit

// MARK: - SCNNode Extensions
public extension SCNNode {
    var tsNode:SCNNode? {
        return self.childNodes.first
    }
    var tsMaterial:SCNMaterial? {
        return self.tsNode?.geometry?.firstMaterial
    }
    
    /// ファイル名からSCNNodeを初期化します。
    /// scn拡張子は必要ありません。
    convenience init?(named name:String) {
        assert(name.suffix(3) != "scn", "There is no need to add scn extenction to SCNNode init(named: _). You should remove it.")
        
        self.init()
        
        let filename = name + ".scn"
        
        guard let modelScene = SCNScene(named: filename) else {
            debugPrint(".scn file named \(name) is not found.")
            return nil
        }
        for childNode in modelScene.rootNode.childNodes {
            self.addChildNode(childNode)
        }
    }
}
