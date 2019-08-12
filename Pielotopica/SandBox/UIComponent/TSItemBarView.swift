//
//  TSItemBarView.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/05.
//  Copyright © 2019 yuki. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/** SandBoxシーンでのアイテムバーを提供します。
 今の所アイテム4つ＋More1つで固定値
 拡張については今後考える。
 
 拡張時はTSItemBarInventoryについても拡張する必要あり。
 */
class TSItemBarView: UIImageView {
    // ======================================================================== //
    // MARK: - TSItemBar Properties -
    var itemBarInventory:TSItemBarInventory!
    
        /// インベントリを開く用ボタン
    let moreitemImageButton = UIButton()
    
    // ======================================================================== //
    // MARK: - Private Properties -
    
    private let disposeBag = DisposeBag()
    
    // ================================== //
    // MARK: - UI Compornents -
    
    /// アイテム保持用ボタンs
    private let itemImageButton1 = TSitemButton()
    private let itemImageButton2 = TSitemButton()
    private let itemImageButton3 = TSitemButton()
    private let itemImageButton4 = TSitemButton()
    
    /// 選択中のアイテムを表すフレーム
    private var itemSelectionFrame = UIImageView(image: #imageLiteral(resourceName: "TS_itembar_item_selected_frame"))
    
    /// 簡易使用用配列
    private var itemImageButtons:[TSitemButton] {
        return [itemImageButton1, itemImageButton2, itemImageButton3, itemImageButton4]
    }
    
    private var allButtons:[UIButton] {
        return itemImageButtons + [moreitemImageButton]
    }
    
    // ======================================================================== //
    // MARK: - Methods -
    
    /// アイテムバーインベントリーをセットします。
    func registerInventory(_ inventory:TSItemBarInventory) {
        self.itemBarInventory = inventory
        
        /// 選択アイテム番号への登録
        self.itemBarInventory.selectedItemIndex.subscribe{[unowned self] in
            $0.element.map(self.onSelectedItemIndexChanged)
            
        }.disposed(by: disposeBag)
        
        /// アイテムスタックへの登録
        self.itemBarInventory.itemStacks.subscribe {[unowned self] in
            $0.element.map(self.onItemStackChanged)
            
        }.disposed(by: disposeBag)
    }
    
    // ======================================================================== //
    // MARK: - Private Methods -
    
    // ================================== //
    // MARK: - Observer -
    
    /// アイテムスタック変更時
    private func onItemStackChanged(to itemStacks:[TSItemStack]) {
        for (i, stack) in itemStacks.enumerated() {
            self.setItemStack(toButtonIndexed: i, stack)
        }
    }
    
    /// 選択中アイテム変更時
    private func onSelectedItemIndexChanged(to index:Int) {
        moveSelectedFrame(to: index)
    }
    
    // ================================== //
    // MARK: - UI Settings -
    
    /// ボタンにアイテムスタックを登録
    private func setItemStack(toButtonIndexed index:Int,_ itemStack:TSItemStack) {
        self.itemImageButtons[index].itemStack = itemStack
    }
    
    /// ボタンに通知を登録します。
    private func registerObserver(to button:UIButton, indexed index:Int) {
        button.rx.tap.subscribe{[unowned self] _ in
            self.onItemButtonPushed(button, indexed: index)
            
            }.disposed(by: disposeBag)
    }
    
    private func setupButtons(indexed index:Int,with button:UIButton) {
        button.frame.origin = [4 + CGFloat(index) * 60, 4]
        button.frame.size = [56, 53]
        
        self.addSubview(button)
    }
    
    private func setupItemButton(_ button:UIButton) {
        button.setBackgroundImage(#imageLiteral(resourceName: "TS_itembar_item_frame"), for: .normal)
    }
    private func _setupView() {
        self.isUserInteractionEnabled = true
        self.clipsToBounds = false
        // サイズ決定
        self.frame.size = [304, 61]
        self.image = #imageLiteral(resourceName: "TS_itembar_background")
        
        self.moreitemImageButton.setImage(#imageLiteral(resourceName: "TS_itembar_more_button"), for: .normal)
        
        self.itemSelectionFrame.frame.size = [70, 67]

        // ボタン初期化
        self.allButtons.enumerated().forEach{
            setupButtons(indexed: $0.offset, with: $0.element)
        }
        
        self.itemImageButtons.enumerated().forEach{
            setupItemButton($0.element)
            registerObserver(to: $0.element, indexed: $0.offset)
        }
        
        self.addSubview(itemSelectionFrame)
        self.addSubview(moreitemImageButton)
    }
    
    // ================================== //
    // MARK: - UI Handler -
    func onItemButtonPushed(_ button:UIButton, indexed index:Int) {
        
        self.itemBarInventory.selectedItemIndex.accept(index)
    }
    
    // ================================== //
    // MARK: - Private APIs -
    
    private func moveSelectedFrame(to index:Int) {
        itemSelectionFrame.frame.origin = [-2 + CGFloat(index) * 60, -2]
    }
    
    // ======================================================================== //
    // MARK: - Constructor -
    override init(frame: CGRect) {
        super.init(frame: frame)
        _setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _setupView()
    }
}
