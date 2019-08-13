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
    var fnode:SCNNode? {
        return self.childNodes.first
    }
    var material:SCNMaterial? {
        return self.fnode?.geometry?.firstMaterial
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
    
    /// ファイル名からSCNNodeを初期化します。
    convenience init?(named name:String,withExtension ex:String = "dae") {
        self.init()
        guard let nodeFromFile = SCNNode.fromFile(named: name,withExtension: ex) else {return nil}
        
        self.addChildNode(nodeFromFile)
    }
    
    /// ファイル名から新規にSCNNodeを作成します。
    static func fromFile(named name:String,withExtension ex:String = "dae", identifier:String? = nil) -> SCNNode? {
        if let identifier = identifier {
            guard
                let url = Bundle.main.url(forResource: name, withExtension: ex),
                let sceneSource = SCNSceneSource(url: url, options: nil)
                else {return nil}
            
            
            guard let node = sceneSource.entryWithIdentifier(identifier, withClass: SCNNode.self) else {
                    return nil
            }
            return node
        }else{
            guard let url = Bundle.main.url(forResource: name, withExtension: ex) else {return nil}
            return try? SCNScene(url: url, options: nil).rootNode
        }
    }
}
