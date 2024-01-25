//
//  PostItemCell.swift
//  NoticeBoard
//
//  Created by 김형진 on 2023/10/27.
//

import UIKit

/**
 게시글 아이템 셀 UI 표시 정보 관리
 */
struct PostItemInfo {
    var index: Int = 0
    var title: String = ""
    var notice: Bool = false
    var reply: Bool = false
    var newItem: Bool = false
    var attachment: Bool = false
    var name: String = ""
    var date: String = ""
    var eye: Bool = false
    var reviewCount: Int = 0
    
    mutating func reset(index: Int, item: PostsValue) {
        self.index = index
        self.title = item.title
        self.notice = item.isNoticePostStyle()
        self.reply = item.isReplyPostStyle()
        self.newItem = item.isNewPost
        self.attachment = item.attachmentsCount > 0
        self.name = item.writer.displayName
        self.date = item.getDateTime()
        self.eye = item.viewCount >= 0
        self.reviewCount = item.viewCount
    }
}

/**
 게시글 아이템 셀
 */
class PostItemCell: UITableViewCell {
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView.make(
            arrangedSubviews: [topStackView,
                               bottomStackView],
            axis: .vertical,
            alignment: .leading,
            spacing: 2,
            distribution: .fill
        )
        return stackView
    }()
    
    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView.make(
            arrangedSubviews: [noticeIcon,
                               replyIcon,
                               titleLabel,
                               attachIcon,
                               newIcon],
            axis: .horizontal,
            alignment: .leading,
            spacing: 4,
            distribution: .fill
        )
        return stackView
    }()
    
    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView.make(
            arrangedSubviews: [nameDateLabel,
                               eyeIcon,
                               reviewLabel],
            axis: .horizontal,
            alignment: .leading,
            spacing: 2,
            distribution: .fill
        )
        return stackView
    }()
    
    private lazy var noticeIcon: UIImageView = {
        let icon = UIImageView(image: .init(named: "badge_notice"))
        return icon
    }()
    
    private lazy var replyIcon: UIImageView = {
        let icon = UIImageView(image: .init(named: "badge_reply"))
        return icon
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.set(font: .systemFont(ofSize: 16), textColor: NBColor.blackCl)
        return label
    }()
    
    private lazy var attachIcon: UIImageView = {
        let icon = UIImageView(image: .init(named: "attachment"))
        return icon
    }()
    
    private lazy var newIcon: UIImageView = {
        let icon = UIImageView(image: .init(named: "badge_new"))
        return icon
    }()
    
    private lazy var nameDateLabel: UILabel = {
        let label = UILabel()
        label.set(font: .systemFont(ofSize: 12), textColor: NBColor.coolGrey)
        return label
    }()
    
    private lazy var eyeIcon: UIImageView = {
        let icon = UIImageView(image: .init(named: "eye"))
        return icon
    }()
    
    private lazy var reviewLabel: UILabel = {
        let label = UILabel()
        label.set(font: .systemFont(ofSize: 12), textColor: NBColor.coolGrey)
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
        contentView.addSubview(mainStackView)
        mainStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(18)
            make.verticalEdges.equalToSuperview().inset(15)
        }
    }
    
    func set(index: Int, item: PostsValue, target: String = "", word: String = "") {
        var info = PostItemInfo()
        info.reset(index: index, item: item)
        
        titleLabel.text = info.title
        noticeIcon.isHidden = !info.notice
        replyIcon.isHidden = !info.reply
        attachIcon.isHidden = !info.attachment
        newIcon.isHidden = !info.newItem
        nameDateLabel.text = "\(info.name) • \(info.date) • "
        eyeIcon.isHidden = !info.eye
        reviewLabel.text = "\(info.reviewCount)"
        
        // target 값이 있을 경우(검색 이 후) word를 강조(오렌지색)해서 보여준다.
        if target == "전체" {
            titleLabel.highlight(word)
            nameDateLabel.highlight(word)
        } else if target == "제목" {
            titleLabel.highlight(word)
        } else if target == "내용" {
            
        } else if target == "작성자" {
            nameDateLabel.highlight(word)
        }
    }
}
