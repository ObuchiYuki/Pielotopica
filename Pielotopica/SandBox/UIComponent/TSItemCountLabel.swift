//
//  TSItemCountLabel.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/10.
//  Copyright © 2019 yuki. All rights reserved.
//

import UIKit

class TSItemCountLabel: UILabel {
    private func _setup() {
        self.textColor = .white
        self.font = TPCommon.Font.pixcel(16)
        self.textAlignment = .right
        self.shadowColor = .black
        self.shadowOffset = [-2, 2]
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _setup()
    }
}
