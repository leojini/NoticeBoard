//
//  UILabel+Ext.swift
//  NoticeBoard
//
//  Created by 김형진 on 2023/10/27.
//

import UIKit

extension UILabel {
    // 레이블 텍스트, 폰트, 색 설정
    func set(text: String? = nil, font: UIFont, textColor: UIColor) {
        if let text { self.text = text }
        self.font = font
        self.textColor = textColor
    }
    
    // 레이블 word를 찾은 후 word를 오렌지색으로 설정
    func highlight(_ word: String) {
        let text = self.text ?? ""
        let range = (text as NSString).range(of: word)
        let attrStr = NSMutableAttributedString(string: text)
        if range.location != NSNotFound {
            attrStr.addAttributes([.foregroundColor: NBColor.orange], range: range)
        }
        self.attributedText = attrStr
    }
}
