//
//  ViewController.swift
//  TPStartScene
//
//  Created by yuki on 2019/07/03.
//  Copyright © 2019 yuki. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: GKGameViewController {
    
    enum Scene {
        case startScene
        case sandbox
    }
    
    var showingScene = Scene.startScene
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = TSLevel()
        
        switch showingScene {
        case .startScene:
            self.presentScene(with: .startScene)
        case .sandbox:
            self.presentScene(with: .sandboxScene)
        }
        
    }
}
