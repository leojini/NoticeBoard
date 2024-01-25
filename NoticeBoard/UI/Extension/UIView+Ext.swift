//
//  UIView+Ext.swift
//  NoticeBoard
//
//  Created by 김형진 on 2023/10/27.
//

import UIKit
import RxSwift
import RxCocoa

extension UIView {
    // 뷰의 코너 라운드 설정
    func roundCorners(
      _ radius: CGFloat,
      corners: CACornerMask = [
        .layerMinXMinYCorner,
        .layerMinXMaxYCorner,
        .layerMaxXMinYCorner,
        .layerMaxXMaxYCorner
      ]
    ) {
        layer.cornerCurve = .continuous
        layer.cornerRadius = radius
        layer.maskedCorners = corners
        clipsToBounds = true
    }
    
    // 뷰의 테두리 설정
    func setBorder(width: CGFloat, color: UIColor) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
}
