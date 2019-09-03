//
//  GKCameraController.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/03.
//  Copyright © 2019 yuki. All rights reserved.
//

import SceneKit
import UIKit


public class GKCameraController {
    private var cameraNavigationController:NSObject?
    private let scnView:SCNView
    

    public init(scnView:SCNView) {
        self.scnView = scnView
        self.scnView.allowsCameraControl = true
        _setup()
        
        cameraNavigationController!.setValue(0.1, forKey: "panSensitivity")
    }
    
    
    @objc private func _handlePan(_ sender: UIPanGestureRecognizer) {
        print("pan")
        cameraNavigationController!.perform(NSSelectorFromString("_handlePan:"), with: sender)
    }
    
    private func _extractTarget(_ gestureRecognizer:UIGestureRecognizer, sel: Selector) -> NSObject? {
        let targets = gestureRecognizer.value(forKey: "_targets") as! NSArray
        let recotarget = targets[0] as! NSObject
            
        let target = recotarget.value(forKey: "target") as! NSObject
            
        gestureRecognizer.setValue(NSMutableArray(), forKey: "_targets")
        gestureRecognizer.addTarget(self, action: sel)

        return target
    }
    
    private func _setup() {
        
        guard let panGestureRecognizer = scnView.gestureRecognizers?.compactMap({$0 as? UIPanGestureRecognizer}).first else {return}
        
        cameraNavigationController = _extractTarget(panGestureRecognizer, sel: #selector(_handlePan))
        
    }
}
