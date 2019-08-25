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
        TSPlayer.him.itemBarInventory.addItemStack(TSItemStack(item: .japaneseHouse2, count: 100))
        TSPlayer.him.itemBarInventory.addItemStack(TSItemStack(item: .woodWall1x5, count: 100))
        
        return true
    }
}

