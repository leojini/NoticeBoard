//
//  BoardsViewController.swift
//  NoticeBoard
//
//  Created by 김형진 on 2023/10/27.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

typealias SelectBoardCl = ((BoardsValue) -> Void)

/**
 게시판 리스트를 보여준다.
 */
class BoardsViewController: UIViewController {
    private lazy var disposeBag = DisposeBag()
    let viewModel = BoardsViewModel()
    var selectBoardCl: SelectBoardCl?
    
    private lazy var closeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(.init(named: "close_x"), for: .normal)
        return btn
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(bgColor: .white)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BoardsItemCell.self, forCellReuseIdentifier: "BoardsItemCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind()
        viewModel.request()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // 뷰 최초 구성
    private func setupViews() {
        view.backgroundColor = .white
        view.roundCorners(8, corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        
        let titleLabel = UILabel()
        let lineView = UIView()
        titleLabel.set(text: "게시판",
                       font: UIFont.systemFont(ofSize: 14),
                       textColor: NBColor.blackCl)
        lineView.backgroundColor = NBColor.boarder
        
        view.addSubview(closeBtn)
        view.addSubview(titleLabel)
        view.addSubview(lineView)
        view.addSubview(tableView)
        
        closeBtn.snp.makeConstraints { make in
            make.left.equalTo(18)
            make.top.equalTo(34)
            make.width.height.equalTo(24)
        }
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(22)
            make.top.equalTo(closeBtn.snp.bottom).offset(23)
        }
        lineView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(13)
            make.height.equalTo(1)
        }
        tableView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(lineView.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // 액션 및 옵저버 처리
    private func bind() {
        closeBtn.rx.tap.subscribe(with: self, onNext: { owner, result in
            owner.dismiss(animated: true)
        }).disposed(by: disposeBag)
        
        viewModel.boards.asObservable()
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(with: self, onNext: { owner, result in
                // 데이터를 받아온 후 테이블 갱신
                owner.tableView.reloadData()
            }).disposed(by: disposeBag)
    }
    
    // 해당 인덱스의 메뉴(게시판)를 선택한다.
    private func selectMenu(_ index: Int) {
        let boards = viewModel.getBoards()
        if index < boards.count {
            let item = boards[index]
            self.dismiss(animated: false) {
                self.selectBoardCl?(item)
            }
        }
    }
}

extension BoardsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getBoards().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let boards = viewModel.getBoards()
        let item = boards[indexPath.row]
        guard let cell: BoardsItemCell =
                tableView.dequeueReusableCell(withIdentifier: "BoardsItemCell",
                                              for: indexPath) as? BoardsItemCell
        else {
            return UITableViewCell()
        }
        cell.set(title: item.displayName)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectMenu(indexPath.row)
    }
}
