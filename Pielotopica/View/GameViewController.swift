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
        print(TSBlock.air)
        print(TSBlock.japaneseHouse2)
        print(TSBlock.ground5x5)
        print(TSBlock.ground5x5Edge)
        print(TSBlock.woodWall1x5)
        
        scnView.showsStatistics = true
        
        self.presentScene(with: .storyScene)
    }
}
