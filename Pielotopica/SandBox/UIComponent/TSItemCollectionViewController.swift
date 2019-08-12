//
//  TSItemCollectionViewController.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/10.
//  Copyright © 2019 yuki. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

// ============================================================== //
// MARK: - Const -
private let kItemCellReuseIdentifier = "__TP_item_collection_cell__"
private let kItemCountHorizontal = 5
private let kItemCountVertical = 10

// ============================================================== //
// MARK: - TPItemCollectionViewController -
public class TSItemCollectionViewController: UICollectionViewController {
    
    // ============================================================== //
    // MARK: - Properties -
    private var inventory:TSInventry{
        return TSSandboxPlayerManager.default.getPlayer().inventory
    }
    
    private let bag = DisposeBag()
    
    // ============================================================== //
    // MARK: - Methods -
    override public func viewDidLoad() {
        self.view.frame.size = TSItemCollectionViewController.viewSize
        self.view.backgroundColor = .init(hex: 0xcccccc)
        self.collectionView.backgroundColor = .clear
        self.collectionView.register(TPItemCollectionViewCell.self, forCellWithReuseIdentifier: kItemCellReuseIdentifier)
        
        inventory.itemStacks.subscribe {[weak self] event in
            self?.collectionView.reloadData()
        }.disposed(by: bag)
    }
    
    override public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return kItemCountVertical * kItemCountHorizontal
    }
    
    override public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kItemCellReuseIdentifier, for: indexPath) as! TPItemCollectionViewCell
        
        let itemStack = self.inventory.itemStacks.value.at(indexPath.row)
        cell.setItemStack(itemStack)
        
        return cell
    }
    
    // ============================================================== //
    // MARK: - Constructor -
    init() {
        super.init(collectionViewLayout: TSItemCollectionViewController.layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(collectionViewLayout: TSItemCollectionViewController.layout)
    }
}

extension TSItemCollectionViewController {
    public override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let itemStack = self.inventory.itemStacks.value.at(indexPath.row) else {return}
        
        let barInventory = TSSandboxPlayerManager.default.getPlayer().itemBarInventory
        barInventory.placeItemStack(itemStack, at: barInventory.selectedItemIndex.value)
    }
}

// ============================================================== //
// MARK: - TPItemCollectionViewController Extension for Const -
extension TSItemCollectionViewController {
    public static let viewSize:CGSize = [64 * CGFloat(kItemCountHorizontal), 61 * CGFloat(kItemCountVertical)]
    
    public static let layout:UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = [64, 61]
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.headerReferenceSize = .zero
        layout.footerReferenceSize = .zero
        
        return layout
    }()
}

// ============================================================== //
// MARK: - TPItemCollectionViewCell (Private class) -

private class TPItemCollectionViewCell: UICollectionViewCell {
    // ============================================================== //
    // MARK: - Properties -
    
    private let backgroundImageView = UIImageView(image: #imageLiteral(resourceName: "TS_itembar_item_frame"))
    private let itemImageView = UIImageView()
    private let countLabel = TSItemCountLabel()
    
    private let disposeBag = DisposeBag()
    
    // ============================================================== //
    // MARK: - Method -
    
    func setItemStack(_ itemStack:TSItemStack?) {
        self._setImage(for: itemStack)
        
        itemStack?.count.subscribe {[unowned self] in
            $0.element.map(self._setCount)
            
        }.disposed(by: disposeBag)
    }
    
    // ============================================================== //
    // MARK: - Private Mathods -
    private func _setImage(for itemStack:TSItemStack?) {
        guard let itemStack = itemStack else {
            self.itemImageView.image = nil
            return
        }
        if let image = itemStack.item.itemImage {
            self.itemImageView.image = image
        } else {
            self.itemImageView.image = nil
        }
    }
    private func _setCount(_ count:Int?) {
        guard let count = count else {
            self.countLabel.text = ""
            return
        }
        if count == 0 {
            self.countLabel.text = ""
            self.itemImageView.image = nil
        } else {
            self.countLabel.text = "\(count)"
        }
    }
    
    private func _setup() {
        self.frame.size = [64, 61]
        self.backgroundImageView.frame.size = [64, 61]
        
        self.itemImageView.frame.size = [64, 61]
        self.itemImageView.contentMode = .scaleAspectFit
        
        self.countLabel.frame.size = [55, 20]
        self.countLabel.frame.origin = [4, 40]
        self.countLabel.textColor = .white
        
        self.contentView.addSubview(backgroundImageView)
        self.contentView.addSubview(itemImageView)
        self.contentView.addSubview(countLabel)
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
