//
//  BoardsItemCell.swift
//  NoticeBoard
//
//  Created by 김형진 on 2023/10/27.
//

import UIKit

/**
 게시판 셀 아이템
 */
class BoardsItemCell: UITableViewCell {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.set(font: .systemFont(ofSize: 16), textColor: NBColor.blackCl)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(22)
            make.verticalEdges.equalToSuperview().inset(12)
        }
    }
    
    func set(title: String) {
        titleLabel.text = title
    }
}

