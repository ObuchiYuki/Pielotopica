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
    
    
    override func sceneDidLoad() {
        self.anchorPoint = [0.5, 0.5]

        roter1.run(.randomRotation(radians: 0.1, duration: 2.5))
        roter2.run(.randomRotation(radians: 0.15, duration: 3))
        roter3.run(.randomRotation(radians: 0.05, duration: 2))
        
        self.addChild(center)
        
        self.addChild(roter1)
        self.addChild(roter2)
        self.addChild(roter3)
    }
    
    private func _createAnimation(for node: SKNode) -> SKAction {
        let a1 = SKAction.run {
            node.run(SKAction.rotate(byAngle: CGFloat.random(in: -3...3), duration: 0.3).setEase(.easeInEaseOut))
        }
        let as1 = SKAction.sequence([a1, .wait(forDuration: 0.3)])
        let as2 = SKAction.repeatForever(as1)
        
        return as2
    }
}

/// Captureシーンで可能な限り負荷を減らすため
/// + Animation用
class RouterViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    private var skView:SKView { return self.view.viewWithTag(1) as! SKView }
    
    enum Route {
        case sandBox
        case capture
    }
    var route:Route = .sandBox
    
    private var timer:Timer?
    
    
    override func viewDidLoad() {
        let scene = _LoaderScene()
        scene.size = skView.frame.size
        scene.backgroundColor = .clear
        scene.scaleMode = .aspectFit
        
        skView.allowsTransparency = true
        skView.presentScene(scene)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        switch route {
        case .sandBox:
            label.text = "読み込み中..."
        case .capture:
            label.text = "人工知能 起動中..."
        }
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {[weak self] timer in
            guard let self = self else {return timer.invalidate()}
            
            UIView.animate(withDuration: 0.5, delay: 0, animations: {
                self.label.alpha = 0.5
            }, completion: nil)
            
            UIView.animate(withDuration: 0.5, delay: 0.5, animations: {
                self.label.alpha = 1
            }, completion: nil)
        })
        
        switch route {
        case .sandBox:
            performSegue(withIdentifier: "to_sandbox", sender: nil)
        case .capture:
            let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "capture") as! TPCaptureViewController
            DispatchQueue.global().async {
                vc.allocAI()
                
                DispatchQueue.main.async {
                    self.skView.isPaused = true
                    self.present(vc, animated: false)
                }
            }
            
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer?.invalidate()
    }
}
