//
//  GKSceneHolder.swift
//  TPStartScene
//
//  Created by yuki on 2019/07/08.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit
import SceneKit

// =============================================================== //
// MARK: - GKSceneHolder -

/**
 同じ背景シーンとSafeシーンの組を都度生成します。
 */
public class GKSceneHolder {
    // =============================================================== //
    // MARK: - Properties -
    /// 保持しているSceneが3dかどうかです。
    var is3d:Bool
    /// 保持しているSceneが2dかどうかです。
    var is2d:Bool
    
    // =============================================================== //
    // MARK: - Methods -
        
    /// 呼び出すたびに新規にSCNSceneを作成します。
    public func generate3DBackgronudScene() -> SCNScene? {
        return _background3DScenegenerator?()
    }
    
    /// 呼び出すたびに新規に背景用SKSceneを作成します。
    public func generateBackgronudScene() -> SKScene? {
        return _backgroundSceneGenerator?()
    }
    
    /// 呼び出すたびに新規にGKSafeSceneを作成します。
    public func generateSafeScene() -> GKSafeScene {
        return _safeSceneGeneratror()
    }
    
    // =============================================================== //
    // MARK: - Private Properties -
    
    /// ジェネレータ
    private let _safeSceneGeneratror: () -> (GKSafeScene)
    private let _backgroundSceneGenerator: (()->(SKScene))?
    private let _background3DScenegenerator: (()->(SCNScene))?
    
    // =============================================================== //
    // MARK: - Constructor -
    init(
        safeScene safeSceneGeneratror:@escaping @autoclosure () -> (GKSafeScene),
        backgroundScene backgroundSceneGenerator:@escaping @autoclosure ()->(SKScene))
    {
        self._safeSceneGeneratror = safeSceneGeneratror
        self._backgroundSceneGenerator = backgroundSceneGenerator
        
        self._background3DScenegenerator = nil
        
        is2d = true
        is3d = false
    }
    
    init(
        safeScene safeSceneGeneratror:@escaping @autoclosure () -> (GKSafeScene),
        background3DScene background3DScenegenerator:@escaping @autoclosure ()->(SCNScene))
    {
        self._safeSceneGeneratror = safeSceneGeneratror
        self._background3DScenegenerator = background3DScenegenerator
        
        self._backgroundSceneGenerator = nil
        
        is2d = false
        is3d = true
    }
}

