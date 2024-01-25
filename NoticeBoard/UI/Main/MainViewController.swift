//
//  MainViewController.swift
//  NoticeBoard
//
//  Created by 김형진 on 2023/10/27.
//

import UIKit
import RxSwift
import RxCocoa
import Realm
import RealmSwift

/**
 앱 시작시 rootViewController
 */
class MainViewController: ViewController {
    lazy var disposeBag = DisposeBag()
    let realm = try! Realm()
    var showBoardVC = false
    
    private lazy var hostLabel: UILabel = {
        let label = UILabel()
        label.text = "호스트 url을 입력해주세요."
        label.set(font: .systemFont(ofSize: 16), textColor: NBColor.blackCl)
        return label
    }()
    
    private lazy var hostTextField: UITextField = {
        let tf = UITextField()
        tf.text = UserDefaultManager.shared.getHostUrl()
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    private lazy var boardsButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("게시판으로 이동", for: .normal)
        btn.setBackgroundColor(color: .init(hex: "#529bba"), forState: .normal)
        return btn
    }()
    
    private lazy var removeRecentsButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("검색 내역 삭제", for: .normal)
        btn.setBackgroundColor(color: .init(hex: "#529bba"), forState: .normal)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        bind()
        
        // 최초 시작시 startApp값을 1로 설정
        UserDefaultManager.shared.setValue(key: NBConstants.startApp, value: "1")
        
        // showBoardVC Notification 등록
        NotificationCenter.default.addObserver(self, selector: #selector(enableShowBoardVC), name: .showBoardVC, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // showBoardVC가 true이면 BoardVieiwContoller을 보여준다.
        if showBoardVC {
            presentBoardsVC(animated: false)
            showBoardVC = false
        }
    }
    
    @objc func enableShowBoardVC() {
        showBoardVC = true
    }
    
    // 뷰 최초 구성
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(boardsButton)
        boardsButton.roundCorners(8)
        boardsButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
            make.width.equalTo(200)
            make.height.equalTo(80)
        }
        
        view.addSubview(removeRecentsButton)
        removeRecentsButton.roundCorners(8)
        removeRecentsButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(50)
            make.width.equalTo(200)
            make.height.equalTo(80)
        }
        
        view.addSubview(hostTextField)
        view.addSubview(hostLabel)
        hostTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(50)
            make.bottom.equalTo(boardsButton.snp.top).offset(-20)
        }
        hostLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(hostTextField.snp.top).offset(-20)
        }
    }
    
    // 액션 및 옵저버 처리
    private func bind() {
        boardsButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self else { return }
            
            let urlString = self.hostTextField.text ?? ""
            
            guard let url = URL(string: urlString) else {
                // 경고창
                let vc: UIAlertController = .init(title: "알림", message: "호스트 url을 올바르게 입력해주세요.", preferredStyle: .alert)
                vc.addAction(.init(title: "확인", style: .default, handler: { action in
    
                }))
                self.present(vc, animated: true)
                return
            }
            
            UserDefaultManager.shared.setHostUrl(url: urlString)
            
            self.presentBoardsVC()
        }).disposed(by: disposeBag)
        
        removeRecentsButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self else { return }
            
            // 최근 검색 내역 삭제 문의 경고창
            let vc: UIAlertController = .init(title: "알림", message: "정말로 검색 내역을 삭제하시겠습니까?", preferredStyle: .alert)
            vc.addAction(.init(title: "확인", style: .default, handler: { action in
                // 삭제 처리
                self.removeRecentItmes {
                    let vc: UIAlertController = .init(title: "알림", message: "모두 삭제했습니다.", preferredStyle: .alert)
                    vc.addAction(.init(title: "확인", style: .default, handler: { action in
                        vc.dismiss(animated: true)
                    }))
                    self.present(vc, animated: true)
                }
            }))
            vc.addAction(.init(title: "취소", style: .default, handler: { action in
                
            }))
            self.present(vc, animated: true)
        }).disposed(by: disposeBag)
    }
    
    // BoardsViewController 를 보여준다.
    private func presentBoardsVC(animated: Bool = true) {
        let boardsVC = BoardsViewController()
        
        // BoardsViewController 모달로 보여지므로 BoardsViewController를 dismiss 후
        // PostsViewController를 보여주기 위해 클로저(selectBoardCl) 처리
        boardsVC.selectBoardCl = { item in
            let postsVC = PostsViewController(
                boardId: item.boardId,
                title: item.displayName
            )
            self.navigationController?.pushViewController(postsVC, animated: true)
        }
        self.present(boardsVC, animated: animated)
    }
    
    // 최근 검색 내역을 제거한다.
    private func removeRecentItmes(complete: @escaping (() -> Void)) {
        let items = realm.objects(RecentItem.self)
        if items.count > 0 {
            items.forEach { item in
                try! realm.write {
                    realm.delete(item)
                    if items.count == 0 {
                        complete()
                    }
                }
            }
        } else {
            complete()
        }
    }
}
