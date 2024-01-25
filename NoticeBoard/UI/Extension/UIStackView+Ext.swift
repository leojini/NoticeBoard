//
//  UIStackView+Ext.swift
//  NoticeBoard
//
//  Created by 김형진 on 2023/10/27.
//

import UIKit

extension UIStackView {
    // UIStackView 생성 편의성을 위해 구현
    static func make(
        arrangedSubviews: [UIView] = [],
        axis: NSLayoutConstraint.Axis,
        alignment: Alignment,
        spacing: CGFloat,
        distribution: Distribution
    ) -> UIStackView {
        let stackView: UIStackView = .init()
        stackView.axis = axis
        stackView.alignment = alignment
        stackView.spacing = spacing
        stackView.distribution = distribution
        stackView.addArrangeSubviews(arrangedSubviews)
        return stackView
    }

    // UIStackView에 여러 뷰들을 추가
    func addArrangeSubviews(_ views: [UIView]) {
        for view in views {
            self.addArrangedSubview(view)
        }
    }
    
    // UIStackView에 추가된 뷰들을 모두 제거
    func removeArragedSubviews() {
        for view in arrangedSubviews {
            removeArrangedSubview(view)
        }
    }
}
