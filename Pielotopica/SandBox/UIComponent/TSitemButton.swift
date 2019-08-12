//
//  TSitemButton.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/07.
//  Copyright © 2019 yuki. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/**
 アイテム表示用のボタンです。
 */
class TSitemButton: UIButton {
    // ============================================================ //
    // MARK: - Property -
    var itemStack:TSItemStack? {
        didSet{
            guard let itemStack = itemStack else { return }
            self._itemStackDidSet(itemStack)
        }
    }
    private let disposeBag = DisposeBag()
    
    // ============================================================ //
    // MARK: - UI Components -
    let countLabel = TSItemCountLabel()

    // ============================================================ //
    // MARK: - Methods -
    override func setNeedsLayout() {
        self._setupView()
    }
    
    // ============================================================ //
    // MARK: - Constructor -
    
    // ============================================================ //
    // MARK: - Private Methods -
    private func _setupView() {
        self.frame.size = [55, 53]
        self.imageView?.contentMode = .scaleAspectFit
        
        self.countLabel.frame.size = [55, 20]
        self.countLabel.frame.origin = [0, 33]
        
        self.addSubview(countLabel)
    }
    
    private func _itemStackDidSet(_ itemStack:TSItemStack){
        itemStack.count.subscribe {[unowned self] event in
            event.element.map(self._setItemCount)
        }.disposed(by: disposeBag)
        
        self._setItemImage(itemStack.item)
    }
    
    private func _setItemCount(_ count:Int) {
        if count == 0 {
            self.countLabel.text = ""
            self.setImage(nil, for: .normal)
        } else {
            self.countLabel.text = "\(count)"
        }
    }
    private func _setItemImage(_ item:TSItem) {
        if let image = item.itemImage {
            self.setImage(image, for: .normal)
        }else{
            self.setImage(nil, for: .normal)
        }
    }
}
