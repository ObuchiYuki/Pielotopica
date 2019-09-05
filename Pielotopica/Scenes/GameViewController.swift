//
//  ViewController.swift
//  TPStartScene
//
//  Created by yuki on 2019/07/03.
//  Copyright © 2019 yuki. All rights reserved.
//

import UIKit
import SpriteKit
import SceneKit

class GameViewController: GKGameViewController {
    
    enum Scene {
        case start
        case sandbox
        case clear
    }
    
    var showingScene = Scene.start
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scnView.allowsCameraControl = true
                
        // for debug
        switch showingScene {
        case .start:
            self.presentScene(with: .startScene)
        case .sandbox:
            self.presentScene(with: .sandboxScene)
        case .clear:
            self.presentScene(with: .gameClear)
        }
        
    }
}
