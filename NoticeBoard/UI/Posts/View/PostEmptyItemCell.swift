//
//  PostEmptyItemCell.swift
//  NoticeBoard
//
//  Created by 김형진 on 2023/10/29.
//

import UIKit

// 게시글, 검색 리스트가 없을 경우 값
enum PostEmptyType {
    case none
    case postEmpty      // 게시글 리스트가 없을 때
    case searchDesc     // 최근 검색어가 없고 검색어를 입력하지 않았을 때
    case searchEmpty    // 검색한 후 리스트가 없을 때
}

/**
 게시글, 검색 리스트가 없을 경우 셀 UI 정보 관리
 */
struct PostEmptyInfo {
    var type: PostEmptyType
    var imageName = ""
    var desc = ""
    var top = 0, width = 0, height = 0
    mutating func reset() {
        switch type {
        case .postEmpty:
            imageName = "post_empty"
            desc = "등록된 게시글이 없습니다."
            top = 178
            width = 152
            height = 160
        case .searchDesc:
            imageName = "search_desc"
            desc = "게시글의 제목, 내용 또는 작성자에 포함된\n단어 또는 문장을 검색해 주세요."
            top = 88
            width = 110
            height = 172
        case .searchEmpty:
            imageName = "search_empty"
            desc = "검색 결과가 없습니다.\n다른 검색어를 입력해 보세요."
            top = 180
            width = 150
            height = 170
        default:
            break
        }
    }
}

/**
 게시글, 검색 리스트가 없을 경우 셀
 */
class PostEmptyItemCell: UITableViewCell {
    private lazy var descImageView: UIImageView = {
        let imageView = UIImageView(image: .init(named: "post_empty"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var descLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.set(font: .systemFont(ofSize: 16), textColor: NBColor.coolGrey2)
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
        backgroundColor = NBColor.coolGrey3
        contentView.addSubview(descImageView)
        contentView.addSubview(descLabel)
        descImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(180)
            make.centerX.equalToSuperview()
            make.width.equalTo(152)
            make.height.equalTo(152)
        }
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(descImageView.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(18)
        }
    }
    
    func set(type: PostEmptyType) {
        var info = PostEmptyInfo(type: type)
        info.reset()
        
        descImageView.image = .init(named: info.imageName)
        descLabel.text = info.desc
        descImageView.snp.remakeConstraints { make in
            make.top.equalToSuperview().inset(info.top)
            make.centerX.equalToSuperview()
            make.width.equalTo(info.width)
            make.height.equalTo(info.height)
        }
    }
}
