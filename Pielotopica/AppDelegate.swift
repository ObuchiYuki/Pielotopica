//
//  AppDelegate.swift
//  TPStartScene
//
//  Created by yuki on 2019/07/03.
//  Copyright © 2019 yuki. All rights reserved.
//

import UIKit
import BoxData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        TSFuelData.shared.setMaxFuel(1000)
        TSFuelData.shared.setMaxHeart(100)
        
        TSItemManager.shared.register(.none)
        //TSItemManager.shared.register(.japaneseHouse2)
        TSItemManager.shared.register(.woodWall1x5)
        TSItemManager.shared.register(.pipotSpawner)
        TSItemManager.shared.register(.targetKari)
        TSItemManager.shared.register(.kiKari)
        TSItemManager.shared.register(.stoneKari)
        TSItemManager.shared.register(.grassKari)
        TSItemManager.shared.register(.ironWall)
        
        TSItemManager.shared.register(.houseRed)
        TSItemManager.shared.register(.houseBlue)
        TSItemManager.shared.register(.houseGreen)
        
        TSItemManager.shared.register(.fuelFactory)
        
        
        // MARK: - 審査用の仮 -
        if TSInventory.shared.itemStacks.value.filter({$0.item != .none}).isEmpty {
            // 初回ならば
            TSInventory.shared.addItem(.woodWall1x5, count: 20)
            TSInventory.shared.addItem(.ironWall, count: 20)
            TSInventory.shared.addItem(.fuelFactory, count: 3)
            TSInventory.shared.addItem(.houseRed, count: 12)
            TSInventory.shared.addItem(.houseBlue, count: 7)
            TSInventory.shared.addItem(.houseGreen, count: 3)
            
            TSMaterialData.shared.addIron(200)
            TSMaterialData.shared.addWood(100)
            TSMaterialData.shared.addCircit(20)
            
            TSFuelData.shared.addFuel(300)
            TSFuelData.shared.addHeart(100)
        }

        print(TSBlock.air)
        print(TSBlock.japaneseHouse2)
        print(TSBlock.ground5x5)
        print(TSBlock.ground5x5Edge)
        print(TSBlock.woodWall)
        print(TSBlock.ironWall)
        
        _=TSLevel()
        
        return true
    }
}

