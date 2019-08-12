//
//  TPCommon.swift
//  TPStartScene
//
//  Created by yuki on 2019/07/07.
//  Copyright © 2019 yuki. All rights reserved.
//

import UIKit

struct TPCommon {
    struct Color {
        static let background:UIColor = #colorLiteral(red: 0.7921568627, green: 0.7725490196, blue: 0.6784313725, alpha: 1)
        static let text:UIColor = #colorLiteral(red: 0.2784313725, green: 0.2666666667, blue: 0.2274509804, alpha: 1)
        static let headerLight:UIColor = #colorLiteral(red: 0.7019607843, green: 0.6823529412, blue: 0.6, alpha: 1)
        static let headerDark:UIColor = #colorLiteral(red: 0.2901960784, green: 0.2784313725, blue: 0.2431372549, alpha: 1)
        static let card:UIColor = #colorLiteral(red: 0.8431372549, green: 0.8196078431, blue: 0.7294117647, alpha: 1)
        static let cardTexture:UIColor = #colorLiteral(red: 0.6470588235, green: 0.631372549, blue: 0.5529411765, alpha: 1)
        static let cardShadow:UIColor = #colorLiteral(red: 0.5921568627, green: 0.5882352941, blue: 0.5058823529, alpha: 1)
        static let cardShadowDark:UIColor = #colorLiteral(red: 0.3450980392, green: 0.3333333333, blue: 0.2941176471, alpha: 1)
        static let icon:UIColor = #colorLiteral(red: 0.2666666667, green: 0.2588235294, blue: 0.2274509804, alpha: 1)
        static let backgroundTextureDark:UIColor = #colorLiteral(red: 0.2823529412, green: 0.2705882353, blue: 0.2352941176, alpha: 1)
        static let backgroundTextureLight:UIColor = #colorLiteral(red: 0.7254901961, green: 0.7098039216, blue: 0.6274509804, alpha: 1)
    }
    struct FontName {
        static let topica = "KorneuburgSlabBold-Bold"
        static let logo = "Silom"
        static let pixcel = "5squared-pixel"
        
    }
    struct AttributeText {
        static let logo = _createLogoAttributeText(with: TPCommon.Color.text)
        static let logoShadow = _createLogoAttributeText(with: TPCommon.Color.cardShadow)
    }
}

private func _createLogoAttributeText(with color:UIColor) -> NSAttributedString {
    let stringAttributes1: [NSAttributedString.Key : Any] = [
        .foregroundColor : color,
        .font : UIFont(name: TPCommon.FontName.logo, size: 46)!,
        .kern: -1.5,
    ]
    
    let string1 = NSMutableAttributedString(string: "P", attributes:stringAttributes1)
    
    let stringAttributes2: [NSAttributedString.Key : Any] = [
        .foregroundColor : color,
        .font : UIFont(name: TPCommon.FontName.logo, size: 40)!,
        .kern: -1.3,
    ]
    
    let string2 = NSAttributedString(string: "ielotopica", attributes:stringAttributes2)
    string1.append(string2)
    
    return string1
}
