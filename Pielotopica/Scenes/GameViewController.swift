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
        case game
        case clear
    }
    
    var showingScene = Scene.game
    
    
    override func viewDidAppear(_ animated: Bool) {
        /// nodeを消す。
        skView.presentScene(SKScene())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                    
        scnView.overlaySKScene = nil
        scnView.autoenablesDefaultLighting = false
        scnView.antialiasingMode = .none
        
        // Aglista-X
        // for debug
        switch showingScene {
        case .start:
            self.presentScene(with: .startScene)
        case .game:
            self.presentScene(with: .gameScene)
        case .clear:
            self.presentScene(with: .gameClear)
        }
        
    }
}
