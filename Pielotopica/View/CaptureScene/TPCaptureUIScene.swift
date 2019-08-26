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
    let gotMatarialBar = _TPCaptureGotMaterialBar()
    let bottomBar = _TPCaptureBottomBar()
    
    func objectDidTouched(objectNamed name:String, with value:TSMaterialValue) {
        self.gotMatarialBar.loadValue(objectNamed: name, value)
    }
    
    override func sceneDidLoad() {
        self.rootNode.addChild(header)
        self.rootNode.addChild(bottomBar)
        self.rootNode.addChild(gotMatarialBar)
        
        bottomBar.backButton.addTarget(self, action: #selector(onBackButtonTap), for: .touchUpInside)
        
    }
    
    @objc private func onBackButtonTap(_ sender:Any) {
        (TPCaptureViewController.initirized!.presentingViewController as! TPRouterViewController).route = .sandBox
        
        TPCaptureViewController.initirized?.dismiss(animated: false, completion: {})
    }
}
