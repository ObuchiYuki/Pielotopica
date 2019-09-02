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
    
    var route:Route = .capture
    
    // ============================================================ //
    // MARK: -  view -
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var loaderSKView:SKView!
    
    private let loaderScene = _TPLoaderScene()
    
    // ============================================================ //
    // MARK: - Methods -
    
    override func viewDidLoad() {
        _setupLoader()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        _startLoader()
        
        self.label.text = _description(for: route)
        
        switch route {
        case .sandBox: _gotoSandBox()
        case .capture: _gotoCapture()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        _stopLoader()
    }

    // ============================================================ //
    // MARK: - Private Methods -
    
    private func _setupLoader() {
        loaderScene.size = loaderSKView.frame.size
        loaderScene.backgroundColor = .clear
        loaderScene.scaleMode = .aspectFit
        
        loaderSKView.allowsTransparency = true
        loaderSKView.presentScene(loaderScene)
    }
    
    private func _startLoader() {
        self.loaderSKView.isPaused = false
        
        loaderScene.start()
    }
    private func _stopLoader() {
        self.loaderSKView.isPaused = true
        
        loaderScene.hideAll()
        
        label.text = ""
    }
    private func _description(for route:Route) -> String {
        switch route {
        case .sandBox:
            return "読み込み中..."
        case .capture:
            return "人工知能 起動中..."
        }
    }
    
    private func _gotoSandBox() {
        performSegue(withIdentifier: "to_sandbox", sender: nil)
    }
    
    private func _gotoCapture() {
        let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "capture") as! TPCaptureViewController
        
        DispatchQueue.global().async {
            vc.allocAI()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.loaderScene.hideAll()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                    self.present(vc, animated: false)
                })
                
            }
        }
    }
}
