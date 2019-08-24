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
class TSBlockPlaceHelper: TPBlockEditHelper {
    
    func startBlockPlacing(at position:TSVector3) {
        guard
            _level.canPlace(block, at: position, atRotation: TSBlockRotation(rotation: _blockRotation)),
            let initialPosition = _level.calculatePlacablePosition(for: block, at: position.vector2)
        else {
            self._didPlaceFail(at: position)
            return
        }
        
        startEditing(from: position, startRotation: 0)
    }
    
    // =============================================================== //
    // MARK: - Private Methods - 
    private func _didPlaceFail(at position:TSVector3) {
        guard let showFailtureNode = guideNode else {return}
        
        delegate?.blockPlaceHelper(failToFindInitialBlockPointWith: showFailtureNode, to: position)
        
        showFailtureNode.runAction(_failt_createFailtureAction())
    }
    
    private func _createFailtureAction() -> SCNAction {
        let redIlluminationAction = SCNAction.run{node in
            node.material?.selfIllumination.contents = UIColor.red
        }
        
        let normaIlluminationAction = SCNAction.run{node in
            node.material?.selfIllumination.contents = UIColor.black
        }
        
        let waitAction = SCNAction.wait(duration: 0.1)
        
        let sequestceAction = SCNAction.sequence([redIlluminationAction,waitAction, normaIlluminationAction, waitAction])
        let repeatAction = SCNAction.repeat(sequestceAction, count: 2)
        
        let removeAction = SCNAction.run{ $0.removeFromParentNode() }
        
        let resultAction = SCNAction.sequence([repeatAction, removeAction])
        
        return resultAction
    }
}
