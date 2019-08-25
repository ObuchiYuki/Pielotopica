//
//  TPCaptureUIScene.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/25.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

class TPCaptureUIScene: GKSafeScene {
    let header = TPHeader()
    let bottomBar = _TPCaptureBottomBar()
    
    override func sceneDidLoad() {
        self.rootNode.addChild(header)
        self.rootNode.addChild(bottomBar)
        
        bottomBar.backButton.addTarget(self, action: #selector(onBackButtonTap), for: .touchUpInside)
        
    }
    
    @objc private func onBackButtonTap(_ sender:Any) {
        (TPCaptureViewController.initirized!.presentingViewController as! RouterViewController).route = .sandBox
        
        TPCaptureViewController.initirized?.dismiss(animated: false, completion: {})
    }
}
