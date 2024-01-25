//
//  PostsViewController.swift
//  NoticeBoard
//
//  Created by 김형진 on 2023/10/27.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

/**
 게시글 리스트를 보여준다.
 검색 리스트를 보여준다.
 */
class PostsViewController: UIViewController {
    
    private lazy var disposeBag = DisposeBag()
    let viewModel = PostsViewModel()
    let titleName: String
    
    // 게시판 네비게이션 메뉴(메뉴 버튼, 게시판 이름, 검색 버튼)
    private lazy var naviBar: NavigationBar = {
        let view = NavigationBar(frame: .zero)
        return view
    }()
    
    // 검색시 메뉴(입력 필드, 취소 버튼)
    lazy var searchBar: SearchBar = {
        let view = SearchBar(frame: .zero, delegate: self)
        view.isHidden = true
        return view
    }()
    
    // 리스트를 보여줄 tableView
    private lazy var tableView: UITableView = {
        let tableView = UITableView(bgColor: NBColor.coolGrey3)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PostItemCell.self, forCellReuseIdentifier: "PostItemCell")
        tableView.register(PostEmptyItemCell.self, forCellReuseIdentifier: "PostEmptyItemCell")
        tableView.register(SearchItemCell.self, forCellReuseIdentifier: "SearchItemCell")
        return tableView
    }()
    
    // BoardsViewController에서 게시판 선택시 boardId, title를 전달받아서 설정한다.
    init(boardId: Int, title: String) {
        self.titleName = title
        super.init(nibName: nil, bundle: nil)
        
        viewModel.boardId = boardId
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind()
        viewModel.requestPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        UserDefaultManager.shared.removeStartApp()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.post(name: .showBoardVC, object: nil)
    }
    
    // 뷰 최초 구성
    private func setupViews() {
        naviBar.setTitle(titleName)
        view.backgroundColor = .white

        view.addSubview(naviBar)
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        naviBar.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(60)
        }
        searchBar.snp.makeConstraints { make in
            make.edges.equalTo(naviBar)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    // 액션 및 옵저버 처리
    private func bind() {
        // 네비게이션바 메뉴 버튼 눌렀을 때
        naviBar.menuButton.rx.tap.subscribe(with: self, onNext: { owner, result in
            // 게시판 리스트 화면으로 돌아간다.
            owner.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
        // 네비게이션바 검색 버튼 눌렀을 때
        naviBar.searchButton.rx.tap.subscribe(with: self, onNext: { owner, result in
            // 검색바의 내용을 초기화한다.
            owner.searchBar.reset()
            owner.searchBar.updatePlaceHolder("\(owner.titleName)에서 검색")
            owner.searchBar.showKeyboard()
            
            // searchMode를 recent로 변경한다.
            owner.viewModel.searchMode.accept(.recent)
        }).disposed(by: disposeBag)
        
        searchBar.clearButton.rx.tap.subscribe(with: self, onNext: { owner, result in
            // 검색바 텍스트 클리어 버튼 눌렀을 때 텍스트를 지운다.
            owner.searchBar.reset()
            owner.viewModel.searchMode.accept(.recent)
        }).disposed(by: disposeBag)
        
        searchBar.cancelButton.rx.tap.subscribe(with: self, onNext: { owner, result in
            // 검색바 취소 버튼 눌렀을 때 searchMode를 none으로 변경한다.
            owner.viewModel.searchMode.accept(.none)
        }).disposed(by: disposeBag)
        
        viewModel.datas.asObservable()
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(with: self, onNext: { owner, result in
                owner.reload()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    // 페이지 로딩 애니메이션을 종료한다.
                    self.tableView.stopLoading()
                }
            }).disposed(by: disposeBag)
        
        // 최근 검색어 갱신시
        viewModel.searchRecentDatas.asObservable()
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(with: self, onNext: { owner, result in
                owner.reload()
            }).disposed(by: disposeBag)
        
        // 검색 응답 완료시
        viewModel.searchDatas.asObservable()
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(with: self, onNext: { owner, result in
                owner.searchBar.updateTarget(owner.viewModel.searchTarget)
                owner.reload()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    // 페이지 로딩 애니메이션을 종료한다.
                    self.tableView.stopLoading()
                }
            }).disposed(by: disposeBag)
        
        // searchMode에 따른 처리
        viewModel.searchMode.asObservable()
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(with: self, onNext: { owner, result in
                switch result {
                case .none: // 게시글 리스트일 경우
                    owner.naviBar.isHidden = false
                    owner.searchBar.isHidden = true
                    owner.searchBar.updateTarget()
                    owner.searchBar.closeKeyboard()
                    owner.reload()
                case .recent: // 검색에서 최근 입력일 경우
                    owner.naviBar.isHidden = true
                    owner.searchBar.isHidden = false
                    owner.searchBar.updateTarget()
                    owner.viewModel.resetRecentItems()
                    owner.reload()
                case .input: // 검색에서 텍스트를 입력한 경우
                    owner.reload()
                case .search: // 서버에 검색 응답을 받은 경우
                    break
                }
            }).disposed(by: disposeBag)
    }
    
    // 리스트를 갱신한다.
    func reload() {
        // 리스트 아이템이 비어 있는지 유무를 확인해서 emptyType을 갱신한다.
        viewModel.resetEmptyType()
        tableView.reloadData()
    }
}


