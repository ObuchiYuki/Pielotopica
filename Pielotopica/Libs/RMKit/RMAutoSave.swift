//
//  RMAutoSave.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/25.
//  Copyright © 2019 yuki. All rights reserved.
//

/**
 自動保存可能な値を表します。
 
 `static var shared = RMAutoSave<Triple>("__key__")`
 のように名前をつけるとその値で、
 
 `static var shared = RMAutoSave<Triple>()`
 付けないと型名で保存されます。
 
 初期値を持たせることもできます.
 `static var shared = RMAutoSave<Int>(initial: 12)`
 
 keyの名前空間はRMStrageと共有なので、重複に注意してください。
 
 ## Usage
 
 ```
 struct Triple: RMAutoSavable {
    static var shared = RMAutoSave<Triple>()
 
    var integer = 1
    var double = 3.14
    var string = "Hello"
 }
 
 
 Triple.shared.integer = 12
 Triple.shared.double = 2.71
 Triple.shared.string = "World"
 
 -- app end --
 -- app start --
 
 print(Triple.shared.integer) // 12
 print(Triple.shared.double) // 2.71
 print(Triple.shared.string) // "World"
 
 ```
 */
public protocol RMAutoSavable:RMStorable{init()};public class RMAutoSave<T:RMAutoSavable>{public var value:T{didSet{RMStorage.shared.store(value,for:RMStorage.Key(rawValue:_key ?? String(describing:type(of:T.self))))}};public init(_ key:String?=nil,initial:T?=nil){value=RMStorage.shared.get(for:RMStorage.Key(rawValue:key ?? String(describing:type(of:T.self)))) ?? initial ?? T();_key=key};private let _key:String?}
