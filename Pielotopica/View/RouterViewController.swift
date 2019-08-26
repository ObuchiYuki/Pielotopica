//
//  RouterViewController.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/20.
//  Copyright © 2019 yuki. All rights reserved.
//

import UIKit
import SpriteKit

private extension SKAction {
    static func randomRotation(radians: CGFloat, duration: TimeInterval) -> SKAction {
        let firstAngle = CGFloat.random(in: 0...3.14)
        
        let a1 = SKAction.customAction(withDuration: duration, actionBlock: {node, time in
            let per = time / CGFloat(duration)
            let theta = firstAngle + CGFloat.pi*2*per
            
            let node = (node as! SKSpriteNode)
            node.anchorPoint = [0.5 + radians * cos(theta), 0.5 + radians * sin(theta)]
            
            node.zRotation = theta
        })
        
        return SKAction.repeatForever(a1)
    }
}

private class _LoaderScene: SKScene {
    let center = SKSpriteNode(imageNamed: "TP_loader_center")
    let roter1 = SKSpriteNode(imageNamed: "TP_loader_router1")
    let roter2 = SKSpriteNode(imageNamed: "TP_loader_router2")
    let roter3 = SKSpriteNode(imageNamed: "TP_loader_router3")
    
    func start() {
        roter1.isHidden = false
        roter2.isHidden = false
        roter3.isHidden = false
        roter1.setScale(0)
        roter2.setScale(0)
        roter3.setScale(0)

        roter1.run(SKAction.scale(to: 1, duration: 0.4).setEase(.easeInEaseOut))
        roter2.run(SKAction.scale(to: 1, duration: 0.4).setEase(.easeInEaseOut))
        roter3.run(SKAction.scale(to: 1, duration: 0.4).setEase(.easeInEaseOut))
    }
    func hideAll() {
        roter1.isHidden = true
        roter2.isHidden = true
        roter3.isHidden = true
        
        roter1.setScale(0)
        roter2.setScale(0)
        roter3.setScale(0)
    }
    
    override func sceneDidLoad() {
        self.anchorPoint = [0.5, 0.5]
        roter1.run(.randomRotation(radians: 0.09, duration: 2.5))
        roter2.run(.randomRotation(radians: 0.06, duration: 3  ))
        roter3.run(.randomRotation(radians: 0.05, duration: 2  ))
            
        self.addChild(center)
        
        self.addChild(roter1)
        self.addChild(roter2)
        self.addChild(roter3)
            
        start()
    }
}

/// Captureシーンで可能な限り負荷を減らすため
/// + Animation用
class RouterViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    private var skView:SKView { return self.view.viewWithTag(1) as! SKView }
    private let scene = _LoaderScene()
    
    enum Route {
        case sandBox
        case capture
    }
    var route:Route = .sandBox
    
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
                
                DispatchQueue.main.async {
                    self.present(vc, animated: false)
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
