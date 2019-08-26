//
//  TPRouterViewController.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/20.
//  Copyright © 2019 yuki. All rights reserved.
//

import UIKit
import SpriteKit

/// Captureシーンで可能な限り負荷を減らすため
/// + Animation用
class TPRouterViewController: UIViewController {
    enum Route {
        case sandBox
        case capture
    }
    
    // ============================================================ //
    // view
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var loaderSKView:SKView!
    
    private let loaderScene = _TPLoaderScene()
    
    
    var route:Route = .capture
    
    private var timer:Timer?
    
    
    override func viewDidLoad() {
        
        scene.size = skView.frame.size
        scene.backgroundColor = .clear
        scene.scaleMode = .aspectFit
        
        skView.allowsTransparency = true
        skView.presentScene(scene)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.skView.isPaused = false
        
        if route == .capture {
            scene.start()
        }
        
        switch route {
        case .sandBox:
            label.text = "読み込み中..."
        case .capture:
            label.text = "人工知能 起動中..."
        }
        
        switch route {
        case .sandBox:
            performSegue(withIdentifier: "to_sandbox", sender: nil)
        case .capture:
            let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "capture") as! TPCaptureViewController
            DispatchQueue.global().async {
                vc.allocAI()
                
                DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                    self.scene.hideAll()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.2, execute: {
                        self.present(vc, animated: false)
                    })
                    
                }
            }
            
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.skView.isPaused = true
        self.scene.hideAll()
        label.text = ""
        timer?.invalidate()
    }
}
