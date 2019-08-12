//
//  GKButtonNode.swift
//  TPStartScene
//
//  Created by yuki on 2019/07/08.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

// =============================================================== //
// MARK: - GKButtonNode -

public class GKButtonNode: SKSpriteNode {
    // =============================================================== //
    // MARK: - enum -

    public enum GKButtonActionType: Int {
        case touchUpInside = 1
        case touchDown
        case touchUp
    }
    
    // =============================================================== //
    // MARK: - Properties -
    
    // ================================= //
    // MARK: - State Controllers -
    /// ボタンが有効かどうかです。
    /// 無効の場合は、disabledTextureが表示されます。
    public var isEnabled: Bool = true {
        didSet {
            if (disabledTexture != nil) {
                texture = isEnabled ? defaultTexture : disabledTexture
            }
        }
    }
    
    /// 選択中かどうかです。
    public var isSelected: Bool = false {
        didSet {
            texture = isSelected ? selectedTexture : defaultTexture
        }
    }
    
    // ================================= //
    // MARK: - Textures -
    /// 標準のテクスチャです。
    public var defaultTexture: SKTexture?
    
    /// 選択中のテクスチャです。（セットしなければ自動生成）
    public var selectedTexture: SKTexture?
    
    /// 無効化中のテクスチャです。（セットしなければ自動生成）
    public var disabledTexture: SKTexture?
    
    
    // =============================================================== //
    // MARK: - Private Properties -
    
    // ================================= //
    // MARK: - Action Selectors -
    private var actionTouchUpInside: Selector?
    private var actionTouchUp: Selector?
    private var actionTouchDown: Selector?
    
    // ================================= //
    // MARK: - Action Senders -
    private weak var targetTouchUpInside: AnyObject?
    private weak var targetTouchUp: AnyObject?
    private weak var targetTouchDown: AnyObject?

    // =============================================================== //
    // MARK: - Constructor -
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    public init(size:CGSize, defaultTexture: SKTexture?=nil, selectedTexture:SKTexture?=nil, disabledTexture: SKTexture?=nil) {
        super.init(texture: defaultTexture, color: .clear, size: size)
        
        self.isUserInteractionEnabled = true
        
        if let defaultTexture = defaultTexture {
            self.defaultTexture = defaultTexture
            self.selectedTexture = selectedTexture ?? generateSelectedTexture(from: defaultTexture)
            self.disabledTexture = disabledTexture ?? generateDisabledTexture(from: defaultTexture)
            
        }
    }

    // =============================================================== //
    // MARK: - Methods -
    
    // =============================== //
    // MARK: - Overriable -
    
    func buttonDidSelect() {}
    func buttonDidUnselect() {}
    
    // =============================== //
    // MARK: - APIs -
    /// ボタンにアクションを追加しましす。
    func addTarget(_ target: AnyObject,action:Selector, for event: GKButtonActionType) {
        
        switch (event) {
        case .touchUpInside:
            targetTouchUpInside = target
            actionTouchUpInside = action
        case .touchDown:
            targetTouchDown = target
            actionTouchDown = action
        case .touchUp:
            targetTouchUp = target
            actionTouchUp = action
        }
        
    }

    // ================================ //
    // MARK: - Overrided Methods -
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isEnabled else { return }
        
        isSelected = true
        self.buttonDidSelect()
        
        // touchDown
        if (targetTouchDown != nil && targetTouchDown!.responds(to: actionTouchDown!)) {
            UIApplication.shared.sendAction(actionTouchDown!, to: targetTouchDown, from: self, for: nil)
        }
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isEnabled else { return }
        
        guard let touchLocation = touches.first?.location(in: parent!) else {return}
        
        isSelected = frame.contains(touchLocation)
        
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isEnabled else { return }
        
        isSelected = false
        buttonDidUnselect()
        
        // touchUpInside
        if (targetTouchUpInside != nil && targetTouchUpInside!.responds(to: actionTouchUpInside!)) {
            guard let touchLocation = touches.first?.location(in: parent!) else {return}
            
            if (frame.contains(touchLocation) ) {
                UIApplication.shared.sendAction(actionTouchUpInside!, to: targetTouchUpInside, from: self, for: nil)
            }
            
        }
        
        // touchUp
        if (targetTouchUp != nil && targetTouchUp!.responds(to: actionTouchUp!)) {
            _ = UIApplication.shared.sendAction(actionTouchUp!, to: targetTouchUp, from: self, for: nil)
        }
    }
    
    // =============================================================== //
    // MARK: - Private Methods -
    
    private func generateSelectedTexture(from defaultTexture: SKTexture) -> SKTexture {
        guard let filter = CIFilter(name: "CIGammaAdjust") else {fatalError()}
        filter.setValue(5, forKey: "inputPower")
        
        return defaultTexture.applying(filter)
    }
    
    private func generateDisabledTexture(from defaultTexture: SKTexture) -> SKTexture {
        return generateSelectedTexture(from: defaultTexture)
    }
}
