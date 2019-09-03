//
//  TPSettingScene.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/03.
//  Copyright © 2019 yuki. All rights reserved.
//

import SceneKit

public extension GKSceneHolder {
    static let setting = GKSceneHolder(safeScene: TPSettingScene(), backgroundScene: TPStartBackgroundScene())
    
}


class TPSettingScene: GKSafeScene {
    private let edgeTopBar = _TPStartSceneEdgeBar()
    private let edgeBottomBar = _TPStartSceneEdgeBar()
    
    private let back = TPFlatButton(textureNamed: "TP_flatbutton_back")
    
    private let mainSlider = TPSettingSlider(title: "Main Volume", volume: 0.3)
    private let seSlider = TPSettingSlider(title: "SE Volume", volume: 0.3)
    
    override func sceneDidLoad() {
        mainSlider.position = [0, 50]
        seSlider.position = [0, -50]
        
         _ = mainSlider.value.subscribe {event in
            GKSoundPlayer.shared.musicVolume = event.element ?? 0
        }
        
        _ = seSlider.value.subscribe {event in
            GKSoundPlayer.shared.seVolume = event.element ?? 0
        }
        
        back.position = [-100, -200]
        
        rootNode.addChild(mainSlider)
        rootNode.addChild(seSlider)
        
        rootNode.addChild(back)
        
        edgeTopBar.position = CGPoint(x: 0, y: GKSafeScene.sceneSize.height/2 - 10)
        edgeBottomBar.position = CGPoint(x: 0, y: -(GKSafeScene.sceneSize.height/2) + 10)
        
        rootNode.addChild(edgeTopBar)
        rootNode.addChild(edgeBottomBar)
    }
}

