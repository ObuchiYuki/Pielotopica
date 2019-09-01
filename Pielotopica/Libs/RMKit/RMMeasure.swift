//
//  RMMeasure.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/30.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

func measure(_ block:()->Void){
    print("Start Mesurement")
    let start = Date()
    block()
    print(Date().timeIntervalSince(start))
}

class RMMeasure {
    private static var times = [_RMTime]()
    
    static func start(_ label:String = #function) {
        print("Start Measurement \"\(label)\"")
        times.append(_RMTime(label: label, start: Date()))
    }
    static func end(_ label:String = #function) {
        guard let time = times.first(where: {$0.label == label}) else {return debugPrint("No time named \(label) found.")}
        times.remove(of: time)
        print(Date().timeIntervalSince(time.start))
    }
}

private struct _RMTime {
    let label:String
    let start:Date
}

extension _RMTime: Equatable & Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(label)
    }
    static func == (left:_RMTime, right:_RMTime) -> Bool {
        left.label == right.label
    }
}
