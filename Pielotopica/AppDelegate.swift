//
//  AppDelegate.swift
//  TPStartScene
//
//  Created by yuki on 2019/07/03.
//  Copyright © 2019 yuki. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        
        TSItemManager.shared.register(.none)
        TSItemManager.shared.register(.japaneseHouse2)
        TSItemManager.shared.register(.woodWall1x5)
        TSItemManager.shared.register(.pipotSpawner)
        TSItemManager.shared.register(.targetKari)
        TSItemManager.shared.register(.kiKari)
        
        print(TSBlock.air)
        print(TSBlock.japaneseHouse2)
        print(TSBlock.ground5x5)
        print(TSBlock.ground5x5Edge)
        print(TSBlock.woodWall1x5)
                
        _ = TSLevel()
        
        
        return true
    }
}

