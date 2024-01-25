//
//  NavigationBar.swift
//  NoticeBoard
//
//  Created by 김형진 on 2023/10/27.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

/**
 게시글 상단 네비게이션바
 메뉴 버튼, 게시판 이름, 검색 버튼
 */
final class NavigationBar: UIView {
    lazy var menuButton: UIButton = {
        let btn = UIButton()
        btn.setImage(.init(named: "menu"), for: .normal)
        return btn
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.set(font: .systemFont(ofSize: 22), textColor: NBColor.blackCl)
        return label
    }()
    
    lazy var searchButton: UIButton = {
        let btn = UIButton()
        btn.setImage(.init(named: "search"), for: .normal)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        backgroundColor = .white
        addSubview(menuButton)
        addSubview(searchButton)
        addSubview(titleLabel)
        menuButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.left.equalTo(18)
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
        searchButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.right.equalToSuperview().inset(18)
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(13)
            make.left.equalTo(menuButton.snp.right).offset(16)
            make.right.equalTo(searchButton.snp.left).inset(6)
        }
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
}
