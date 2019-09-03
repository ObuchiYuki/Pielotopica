//
//  TPStartScene.swift
//  TPStartScene
//
//  Created by yuki on 2019/07/03.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

public extension GKSceneHolder {
    static let startScene = GKSceneHolder(safeScene: TPStartScene(), backgroundScene: TPStartBackgroundScene())
    
}

// =============================================================== //
// MARK: - TPStartScene -

class TPStartScene:GKSafeScene {
    // =============================================================== //
    // MARK: - Private Properties -
    
    // =============================== //
    // MARK: - Main Item -
    private let logo = _TPStartSceneLogo()
    private let ring = _TPStartSceneRing()
    
    // =============================== //
    // MARK: - Tab items -
    private let tabitemSetting = _TPStartSceneTabItem(iconImageNamed: "TP_startmenu_tabitem_icon_setting", title: "setting")
    private let tabitemNotice = _TPStartSceneTabItem(iconImageNamed: "TP_startmenu_tabitem_icon_notice", title: "notice")
    private let tabitemStage = _TPStartSceneTabItem(iconImageNamed: "TP_startmenu_tabitem_icon_stage", title: "stage")
    
    // =============================== //
    // MARK: - Edge bars -
    private let edgeTopBar = _TPStartSceneEdgeBar()
    private let edgeBottomBar = _TPStartSceneEdgeBar()
    
    // =============================== //
    // MARK: - Pattern -
    private let pattrens = _TPStartScenePatterns()
    
    // =============================================================== //
    // MARK: - Methods -
    override func sceneDidAppear() {
        (self.gkViewContoller as! GameViewController).showingScene = .start
    }
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        
        ring.addTarget(self, action: #selector(onRingSelected), for: .touchUpInside)
        tabitemSetting.addTarget(self, action: #selector(onSettingTap), for: .touchUpInside)
        
        self._setup()
    }
    
    // =============================================================== //
    // MARK: - Private Methods -
    
    // =============================== //
    // MARK: - Handlers -
    @objc private func onSettingTap(_ sender:GKButtonNode) {
        GKSoundPlayer.shared.playSoundEffect(.ring)
        self.present(to: .setting)
    }
    
    @objc private func onRingSelected(_ sender:GKButtonNode) {
        _endup()
        
        self.present(to: .sandboxScene, delayed: 0.1)
        
    }
    
    // =============================== //
    // MARK: - Setup -
    private func _setup(){
        _setupPatterns()
        _setupTabitem()
        _setupBars()
        _setupRing()
        _setupLogo()
    }
    private func _endup() {
        
    }
    
    private func _setupTabitem() {
        tabitemSetting.position = [-130, -220]
        tabitemNotice.position = [0, -220]
        tabitemStage.position = [130, -220]
        
        rootNode.addChild(tabitemSetting)
        rootNode.addChild(tabitemNotice)
        rootNode.addChild(tabitemStage)
    }
    
    private func _setupPatterns() {
        pattrens.position.y = -25
        
        rootNode.addChild(pattrens)
    }
    
    private func _setupRing() {
        ring.position.y = -25
        
        rootNode.addChild(ring)
    }
    
    private func _setupBars() {
        edgeTopBar.position = CGPoint(x: 0, y: GKSafeScene.sceneSize.height/2 - 10)
        edgeBottomBar.position = CGPoint(x: 0, y: -(GKSafeScene.sceneSize.height/2) + 10)
        
        rootNode.addChild(edgeTopBar)
        rootNode.addChild(edgeBottomBar)
    }
    
    private func _setupLogo() {
        logo.position.y = GKSafeScene.sceneSize.height/2 - 100
        
        rootNode.addChild(logo)
    }
}
