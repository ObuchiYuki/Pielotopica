//
//  TPBuildNotice.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/02.
//  Copyright © 2019 yuki. All rights reserved.
//

import UIKit

struct TPBuildNotice {
    
    static func show(_ notice: TPBuildNotice) {
        RMBindCenter.default.post(name: .TPBuildNotification, object: notice)
    }
    
    let color:UIColor
    let text:String
}

extension RMBinder.Name where Object == TPBuildNotice {
    static let TPBuildNotification = RMBinder.Name(rawValue: "TPBuildNotification")
}
