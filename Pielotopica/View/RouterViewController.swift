//
//  RouterViewController.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/20.
//  Copyright © 2019 yuki. All rights reserved.
//

import UIKit

/// Captureシーンで可能な限り負荷を減らすため
/// + Animation用
class RouterViewController: UIViewController {
    enum Route {
        case sandBox
        case capture
    }
    
    @IBOutlet weak var label: UILabel!
    var route:Route = .sandBox
    
    private var timer:Timer?
    
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
            let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "capture") as! CaptureViewController
            DispatchQueue.global().async {
                vc.allocAI()
                
                DispatchQueue.main.async {
                    self.present(vc, animated: false)
                }
            }
            
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer?.invalidate()
    }
}
