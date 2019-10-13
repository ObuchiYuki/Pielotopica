//
//  TPBuildNotice.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/02.
//  Copyright © 2019 yuki. All rights reserved.
//

import UIKit

struct TPBuildNotice {
    
    static func show(text:String, color:UIColor = .white) {
        RMBindCenter.default.post(name: .TPBuildNotification, object: TPBuildNotice(text: text, color: color))
    }
    
    let text:String
    let color:UIColor
    
    init(text:String, color:UIColor) {
        self.text = text
        self.color = color
    }
}

extension RMBinder.Name where Object == TPBuildNotice {
    static let TPBuildNotification = RMBinder.Name(rawValue: "__TPBuildNotification__")
}
