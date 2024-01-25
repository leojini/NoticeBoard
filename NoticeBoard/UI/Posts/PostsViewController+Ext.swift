//
//  PostsViewController+Ext.swift
//  NoticeBoard
//
//  Created by 김형진 on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

extension PostsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.searchMode.value {
        case .input: // 검색에서 텍스트를 입력한 경우
            return viewModel.targetNames.count
        case .recent: // 검색에서 최근 입력일 경우
            if viewModel.isEmptySearch() {
                return 1
            }
            return viewModel.getRecents().count
        case .search: // 서버에 검색 응답을 받은 경우
            if viewModel.isEmptySearch() {
                return 1
            }
            return viewModel.getSearchs().count
        default: // 게시글 리스트일 경우
            if viewModel.isEmptyPost() {
                return 1
            }
            return viewModel.getPosts().count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.searchMode.value {
        case .input: // 검색에서 텍스트를 입력한 경우
            return getSearchItemCell(tableView, indexPath: indexPath)
        case .recent: // 검색에서 최근 입력일 경우
            if viewModel.isEmptySearch() {
                return getPostEmptyCell(tableView, indexPath: indexPath)
            } else {
                return getSearchItemCell(tableView, indexPath: indexPath)
            }
        case .search: // 서버에 검색 응답을 받은 경우
            if viewModel.isEmptySearch() {
                return getPostEmptyCell(tableView, indexPath: indexPath)
            } else {
                return getPostItemCell(tableView, indexPath: indexPath)
            }
        default: // 게시글 리스트일 경우
            if viewModel.isEmptyPost() {
                return getPostEmptyCell(tableView, indexPath: indexPath)
            } else {
                return getPostItemCell(tableView, indexPath: indexPath)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let posts = viewModel.getPosts()
        
        // 마지막 셀인 경우
        if indexPath.row + 1 == posts.count, tableView.tableFooterView == nil {
            switch viewModel.searchMode.value {
            case .input, .recent, .search: // 검색 관련
                break
            default: // 게시글 리스트일 경우
                if viewModel.requestPostsNext() {
                    // 서버에 다음 페이지 요청한 후 로딩 애니메이션을 보여준다.
                    tableView.startLoading(indexPath)
                }
            }
        }
    }
}

extension PostsViewController {
    // 리스트 아이템이 없을 때 셀을 반환한다.
    func getPostEmptyCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell: PostEmptyItemCell =
                tableView.dequeueReusableCell(withIdentifier: "PostEmptyItemCell",
                                              for: indexPath) as? PostEmptyItemCell
        else {
            return UITableViewCell()
        }
        cell.set(type: viewModel.getEmptyType())
        return cell
    }
    
    // 게시글 리스트 혹은 검색 리스트일 경우 셀을 반환한다.
    func getPostItemCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell: PostItemCell =
            tableView.dequeueReusableCell(withIdentifier: "PostItemCell", for: indexPath) as? PostItemCell
        else {
            return UITableViewCell()
        }
        
        // 게시글 데이터를 검색 유무에 따라 설정
        let posts = (viewModel.searchMode.value == .search) ? viewModel.getSearchs() : viewModel.getPosts()
        let item = posts[indexPath.row]
        if viewModel.searchMode.value == .search {
            cell.set(index: indexPath.row, item: item, target: viewModel.searchTarget, word: viewModel.searchWord)
        } else {
            cell.set(index: indexPath.row, item: item)
        }
        return cell
    }
    
    // 검색화면에서 최근 입력 또는 텍스트를 입력한 경우 셀을 반환한다.
    func getSearchItemCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard var cell: SearchItemCell =
            tableView.dequeueReusableCell(withIdentifier: "SearchItemCell", for: indexPath) as? SearchItemCell
        else {
            return UITableViewCell()
        }
        
        if viewModel.searchMode.value == .recent {
            // 검색에서 최근 입력일 경우 셀을 구성한다.
            let recents = viewModel.getRecents()
            cell = makeRecentItemCell(cell: cell, item: recents[indexPath.row], index: indexPath.row)
        } else if viewModel.searchMode.value == .input {
            // 검색에서 텍스트를 입력한 경우 셀을 구성한다.
            let targets = viewModel.targetNames
            var target = ""
            if indexPath.row < targets.count {
                target = targets[indexPath.row]
            }
            cell = makeInputItemCell(cell: cell, target: target, index: indexPath.row)
        }
        return cell
    }
    
    // 검색화면에서 최근 입력일 경우 셀을 구성한다.
    private func makeRecentItemCell(cell: SearchItemCell,
                                     item: RecentItem,
                                     index: Int) -> SearchItemCell
    {
        var info = SearchItemInfo()
        info.resetRecentItem(index: index, item: item)
        
        // 최근 입력 아이템을 선택한 경우 클로저
        let selectCl: SelectItemCl = { index in
            self.searchBar.setText(item.word)
            // 최근 입력 아이템을 서버에 조회한다.
            self.viewModel.requestSearch(target: item.target,
                                         word: item.word)
        }
        
        // 최근 입력 아이템에서 x 버튼을 누를 경우 클로저
        let closeCl: SelectItemCl = { index in
            DBManager.shared.removeRecentItem(target: item.target, word: item.word) {
                DispatchQueue.main.async {
                    // 최근 입력 데이터를 삭제한 후 리스트를 갱신한다.
                    self.viewModel.resetRecentItems()
                    self.reload()
                }
            }
        }
        
        cell.set(info: info,
                 selectCl: selectCl,
                 closeCl: closeCl)
        return cell
    }
    
    // 검색화면에서 텍스트를 입력한 경우 셀을 구성한다.
    private func makeInputItemCell(cell: SearchItemCell,
                                    target: String,
                                    index: Int) -> SearchItemCell
    {
        var info = SearchItemInfo()
        info.resetInputItem(index: index,
                            target: target as NSString,
                            word: viewModel.inputWord)
        
        // 입력된 텍스트를 선택한 경우 클로저
        let selectCl: SelectItemCl = { index in
            // 입력된 텍스트로 서버에 조회한다.
            self.viewModel.requestSearch(target: target,
                                         word: self.viewModel.inputWord)
        }
        
        cell.set(info: info,
                 selectCl: selectCl,
                 closeCl: { _ in })
        return cell
    }
}

extension PostsViewController: SearchBarDelegate {
    // 검색화면에서 키보드에서 검색 버튼 혹은 입력된 아이템을 선택한 경우 서버에 조회한다.
    func searchWord(word: String) {
        let target = (viewModel.searchTarget.isEmpty) ? "전체" : viewModel.searchTarget
        viewModel.requestSearch(target: target, word: word)
    }
    
    // 키보드의 텍스트 변경시마다 호출된다.
    func changeWord(word: String) {
        let wordExtEmpty = word.replacingOccurrences(of: " ", with: "")
        
        if wordExtEmpty.isEmpty {
            // 텍스트가 없는 경우 serachMode를 recent로 변경한다.
            viewModel.searchMode.accept(.recent)
        } else {
            // 텍스트가 있는 경우 serachMode를 input으로 변경한다.
            viewModel.inputWord = word
            viewModel.searchMode.accept(.input)
        }
    }
}
