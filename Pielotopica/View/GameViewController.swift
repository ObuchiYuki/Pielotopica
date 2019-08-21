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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: - For Debug -
        
        self.presentScene(with: .storyScene)
    }
}
