//
//  SearchItemCell.swift
//  NoticeBoard
//
//  Created by 김형진 on 2023/10/29.
//

import UIKit
import RxSwift

typealias SelectItemCl = ((Int) -> Void)

/**
 검색 아이템 셀 UI 정보 관리
 */
struct SearchItemInfo {
    var index: Int = 0
    var clock: Bool = false
    var target: String = ""
    var word: String = ""
    var close: Bool = false
    var right: Bool = false
    
    mutating func resetRecentItem(index: Int, item: RecentItem) {
        self.index = index
        self.clock = true
        self.target = "\(item.target) :"
        self.word = item.word
        self.close = true
        self.right = false
    }
    
    mutating func resetInputItem(index: Int, target: NSString, word: String) {
        self.index = index
        self.clock = false
        self.target = "\(target) :"
        self.word = word
        self.close = false
        self.right = true
    }
}

/**
 검색 아이템 셀
 */
class SearchItemCell: UITableViewCell {
    private lazy var disposeBag = DisposeBag()
    private var index = 0
    private var selectCl: SelectItemCl?
    private var closeCl: SelectItemCl?
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView.make(arrangedSubviews:
                                            [clockIcon,
                                             targetLabel,
                                             wordLabel],
                                         axis: .horizontal,
                                         alignment: .leading,
                                         spacing: 8,
                                         distribution: .fill)
        return stackView
    }()
    
    private lazy var clockIcon: UIImageView = {
        let icon = UIImageView(image: .init(named: "clock"))
        return icon
    }()
    
    private lazy var targetLabel: UILabel = {
        let label = UILabel()
        label.set(font: .systemFont(ofSize: 14), textColor: NBColor.coolGrey2)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var wordLabel: UILabel = {
        let label = UILabel()
        label.set(font: .systemFont(ofSize: 16), textColor: NBColor.blackCl)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var rightIcon: UIImageView = {
        let icon = UIImageView(image: .init(named: "caret_right"))
        return icon
    }()
    
    private lazy var line: UIView = {
        let view = UIView()
        view.backgroundColor = NBColor.boarder
        return view
    }()
    
    private lazy var bgButton: UIButton = {
        let btn = UIButton()
        return btn
    }()
    
    private lazy var closeButton: UIButton = {
        let btn = UIButton()
        return btn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupSubviews()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        [stackView, rightIcon, line, bgButton, closeButton].forEach { view in
            contentView.addSubview(view)
        }
        
        stackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(18)
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12)
            make.right.equalTo(rightIcon.snp.left).offset(-4)
        }
        targetLabel.snp.makeConstraints { make in
            make.width.equalTo(30)
            make.centerY.equalToSuperview()
        }
        wordLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
        }
        clockIcon.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerY.equalToSuperview()
        }
        rightIcon.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-18)
            make.width.height.equalTo(18)
            make.centerY.equalToSuperview()
        }
        line.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
        bgButton.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(2)
            make.horizontalEdges.equalToSuperview().inset(18)
        }
        closeButton.snp.makeConstraints { make in
            make.edges.equalTo(rightIcon).inset(-10)
        }
    }
    
    private func updateBgButton(_ exceptCloseButtonArea: Bool) {
        if exceptCloseButtonArea { // X 버튼 영역을 제외한 부분으로 변경
            bgButton.snp.remakeConstraints { make in
                make.verticalEdges.equalToSuperview().inset(2)
                make.left.equalToSuperview().inset(18)
                make.right.equalTo(closeButton.snp.left).offset(-4)
            }
        } else { // 셀 전체 영역으로 변경
            bgButton.snp.remakeConstraints { make in
                make.verticalEdges.equalToSuperview().inset(2)
                make.horizontalEdges.equalToSuperview().inset(18)
            }
        }
    }
    
    private func bind() {
        bgButton.rx.tap.subscribe(with: self, onNext: { owner, result in
            owner.selectCl?(self.index)
        }).disposed(by: disposeBag)
        
        closeButton.rx.tap.subscribe(with: self, onNext: { owner, result in
            owner.closeCl?(self.index)
        }).disposed(by: disposeBag)
    }
    
    func set(info: SearchItemInfo,
             selectCl: @escaping SelectItemCl,
             closeCl: @escaping SelectItemCl)
    {
        self.index = info.index
        clockIcon.isHidden = !info.clock
        
        targetLabel.text = info.target
        let width = targetLabel.intrinsicContentSize.width
        targetLabel.snp.updateConstraints { make in
            make.width.equalTo(width)
        }
        
        wordLabel.text = info.word
        
        if info.close {
            rightIcon.image = .init(named: "close_grey")
            closeButton.isHidden = false
            updateBgButton(true)
        } else if info.right {
            rightIcon.image = .init(named: "caret_right")
            closeButton.isHidden = true
            updateBgButton(false)
        }
        self.selectCl = selectCl
        self.closeCl = closeCl
    }
}

