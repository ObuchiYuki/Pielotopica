//
//  ViewController.swift
//  TPStartScene
//
//  Created by yuki on 2019/07/03.
//  Copyright © 2019 yuki. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: GKGameViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scnView.allowsCameraControl = true
        
        self.presentScene(with: .storyScene)
    }
}
