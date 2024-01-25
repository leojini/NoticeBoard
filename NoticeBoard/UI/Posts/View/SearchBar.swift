//
//  SearchBar.swift
//  NoticeBoard
//
//  Created by 김형진 on 2023/10/29.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

// 검색 화면에서의 상태
enum SearchMode {
    case none        // 게시글 리스트
    case recent      // 최근 검색어
    case input       // 검색어 입력
    case search      // 검색 이 후
}

protocol SearchBarDelegate: NSObject {
    // 텍스트 필드 변경시 마다 호출된다.
    func changeWord(word: String)
    
    // 키보드의 검색 버튼이 눌렸을 때 호출된다.
    func searchWord(word: String)
}

/**
 게시글 검색시 상단바
 검색 이미지, 텍스트 필드, 취소 버튼
 */
final class SearchBar: UIView, UITextFieldDelegate {
    let delegate: SearchBarDelegate
    private lazy var searchImage: UIImageView = {
        let image = UIImageView(image: .init(named: "search"))
        return image
    }()
    
    private lazy var targetLabel: UILabel = {
        let label = UILabel()
        label.set(font: .systemFont(ofSize: 14), textColor: NBColor.coolGrey2)
        return label
    }()
    
    private lazy var textField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "일반 게시판에서 검색"
        tf.textColor = NBColor.blackCl
        tf.returnKeyType = .search
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.smartDashesType = .no
        tf.smartQuotesType = .no
        tf.smartInsertDeleteType = .no
        tf.enablesReturnKeyAutomatically = true
        tf.delegate = self
        return tf
    }()
    
    // 입력된 텍스트 삭제 버튼. 편의 버튼.
    lazy var clearButton: UIButton = {
        let btn = UIButton()
        btn.setImage(.init(named: "close_grey"), for: .normal)
        btn.isHidden = true
        return btn
    }()
    
    lazy var cancelButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("취소", for: .normal)
        btn.setTitleColor(NBColor.coolGrey2, for: .normal)
        return btn
    }()
    
    init(frame: CGRect, delegate: SearchBarDelegate) {
        self.delegate = delegate
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        backgroundColor = .white
        
        let bgView = UIView()
        bgView.backgroundColor = NBColor.coolGrey3
        bgView.roundCorners(4)
        bgView.addSubview(searchImage)
        bgView.addSubview(targetLabel)
        bgView.addSubview(textField)
        bgView.addSubview(clearButton)
        
        addSubview(bgView)
        addSubview(cancelButton)
        
        bgView.snp.makeConstraints { make in
            make.left.equalTo(18)
            make.right.equalTo(cancelButton.snp.left).offset(-6)
            make.verticalEdges.equalToSuperview().inset(10)
        }
        searchImage.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        targetLabel.snp.makeConstraints { make in
            make.left.equalTo(searchImage.snp.right).offset(5)
            make.width.equalTo(0)
            make.centerY.equalToSuperview()
        }
        textField.snp.makeConstraints { make in
            make.left.equalTo(targetLabel.snp.right)
            make.right.equalToSuperview().offset(-26)
            make.centerY.equalToSuperview()
            make.height.equalTo(24)
        }
        clearButton.snp.makeConstraints { make in
            make.left.equalTo(textField.snp.right).offset(2)
            make.centerY.equalTo(bgView)
            make.width.equalTo(18)
            make.height.equalTo(18)
        }
        cancelButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(18)
            make.centerY.equalTo(bgView)
            make.width.equalTo(40)
            make.height.equalTo(24)
        }
    }
    
    func reset() {
        setText("")
    }
    
    func setText(_ text: String) {
        textField.text = text
        
        // 텍스트 유무에 따라 clearButton 숨김 처리를 한다.
        if text.isEmpty {
            clearButton.isHidden = true
        } else {
            clearButton.isHidden = false
        }
    }
    
    func showKeyboard() {
        textField.becomeFirstResponder()
    }
    
    func closeKeyboard() {
        textField.resignFirstResponder()
    }
    
    func updatePlaceHolder(_ placeHolder: String) {
        textField.placeholder = placeHolder
    }
    
    func updateTarget(_ text: String = "") {
        let word = (text.isEmpty) ? "" : "\(text) :"
        targetLabel.text = word
        
        // targetLabel 입력된 텍스트 넓이를 갱신한다.
        var width = targetLabel.intrinsicContentSize.width
        if !word.isEmpty {
            // 입려된 텍스트가 있다면 여백을 둔다.
            width += 6
        }
        targetLabel.snp.updateConstraints({ make in
            make.width.equalTo(width)
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            let textRemoveEmpty = text.replacingOccurrences(of: " ", with: "")
            
            // 검색어가 있을 경우
            if !textRemoveEmpty.isEmpty {
                delegate.searchWord(word: text)
                textField.resignFirstResponder()
            }
        }
        return true
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.delegate.changeWord(word: textField.text ?? "")
            if let text = textField.text {
                // 텍스트 유무에 따라 clearButton 숨김 처리를 한다.
                if text.isEmpty {
                    self.clearButton.isHidden = true
                } else {
                    self.clearButton.isHidden = false
                }
            }
        }
        return true
    }
}

