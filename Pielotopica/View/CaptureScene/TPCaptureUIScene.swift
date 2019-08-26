//
//  TPCaptureUIScene.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/25.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

class TPCaptureUIScene: GKSafeScene {
    private let header = TPHeader()
    private let gotMatarialBar = _TPCaptureGotMaterialBar()
    private let bottomBar = _TPCaptureBottomBar()
    
    func showPrediction(withObjectNamed name:String, value:TSMaterialValue) {
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
