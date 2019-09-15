//
//  TSBlockPlaceHelper.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/16.
//  Copyright © 2019 yuki. All rights reserved.
//

import RxCocoa
import RxSwift
import SceneKit

// =============================================================== //
// MARK: - TSBlockPlaceHelper -

/// ブロック設置の補助をします。
/// ジェスチャー・置かれたかどうかなど。
class TPBlockPlaceHelper: TPBlockEditHelper {
    
    func startBlockPlacing(at position:TSVector3) -> Bool {
        guard editor.canPlaceBlock(block, at: position, rotation: .x0) else {
            self._didPlaceFail(at: position)
            return false
        }
        
        self.startEditing(from: position, startRotation: 0)
        
        return true
    }
    
    // =============================================================== //
    // MARK: - Private Methods - 
    private func _didPlaceFail(at position:TSVector3) {
        TPBuildNotice.show(text: "ここにはブロックを置けません。", color: TPCommon.Color.dangerous)
    }
    
    private func _createFailtureAction() -> SCNAction {
        let redIlluminationAction = SCNAction.run{node in
            node.fmaterial?.selfIllumination.contents = UIColor.red
        }
        
        let normaIlluminationAction = SCNAction.run{node in
            node.fmaterial?.selfIllumination.contents = UIColor.black
        }
        
        let waitAction = SCNAction.wait(duration: 0.1)
        
        let sequestceAction = SCNAction.sequence([redIlluminationAction,waitAction, normaIlluminationAction, waitAction])
        let repeatAction = SCNAction.repeat(sequestceAction, count: 2)
        
        let removeAction = SCNAction.run{ $0.removeFromParentNode() }
        
        let resultAction = SCNAction.sequence([repeatAction, removeAction])
        
        return resultAction
    }
}
