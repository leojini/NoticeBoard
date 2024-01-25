//
//  UITableView+Ext.swift
//  NoticeBoard
//
//  Created by 김형진 on 2023/10/28.
//

import UIKit

extension UITableView {
    // UITableView 생성 편의성을 위해 구현
    convenience init(bgColor: UIColor) {
        self.init(frame: .zero, style: .plain)
        self.bounces = false
        self.backgroundColor = bgColor
        self.separatorStyle = .none
    }
    
    // 하단 indicatorView를 tableFooterView에 설정한다.
    func indicatorView() -> UIActivityIndicatorView{
        var activityIndicatorView = UIActivityIndicatorView()
        if self.tableFooterView == nil {
            let indicatorFrame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 80)
            activityIndicatorView = UIActivityIndicatorView(frame: indicatorFrame)
            activityIndicatorView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
            activityIndicatorView.style = .medium
            activityIndicatorView.color = .gray
            activityIndicatorView.hidesWhenStopped = true
            self.tableFooterView = activityIndicatorView
            return activityIndicatorView
        }
        else {
            return activityIndicatorView
        }
    }

    // indicatorView의 애니메이션을 시작
    func startLoading(_ indexPath:IndexPath){
        indicatorView().startAnimating()
    }

    // indicatorView의 애니메이션을 종료
    func stopLoading() {
        if self.tableFooterView != nil {
            self.indicatorView().stopAnimating()
            self.tableFooterView = nil
        }
    } 
}
