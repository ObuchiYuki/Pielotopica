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
        log.debug(TSBlock.air)
        log.debug(TSBlock.japaneseHouse2)
        log.debug(TSBlock.ground5x5)
        log.debug(TSBlock.ground5x5Edge)
        log.debug(TSBlock.woodWall1x5)
        
        scnView.showsStatistics = true
        
        self.presentScene(with: .storyScene)
    }
}
