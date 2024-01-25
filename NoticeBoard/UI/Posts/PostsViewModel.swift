//
//  PostsViewModel.swift
//  NoticeBoard
//
//  Created by 김형진 on 2023/10/27.
//

import Foundation
import RxSwift
import RxRelay
import Moya

/**
 게시글, 검색 관련 뷰 모델
 */
class PostsViewModel {
    private lazy var disposeBag = DisposeBag()
    
    // 게시글 리스트 데이터
    let datas = BehaviorRelay<[PostsValue]>(value: [])
    
    // 최근 검색 리스트 데이터
    let searchRecentDatas = BehaviorRelay<[RecentItem]>(value: [])
    
    // 검색한 이 후 리스트 데이터
    let searchDatas = BehaviorRelay<[PostsValue]>(value: [])
    
    // 검색 모드(게시글 리스트, 최근 검색어, 검색어 입력, 검색 조회한 후)
    let searchMode = BehaviorRelay<SearchMode>(value: .none)
    
    // 게시판 아이디
    var boardId = 0
    
    // 검색 타겟 분류
    let targetNames: [String] = ["전체", "제목", "내용", "작성자"]
    
    // 게시글 오프셋
    private var currOffset = 0
    
    // 검색 조회 후 타겟 저장
    var searchTarget = ""
    
    // 검색 조회 후 검색어 저장
    var searchWord = ""
    
    // 입력한 텍스트
    var inputWord = ""
    
    // 리스트 데이터가 비어있을 경우 구분값
    private var emptyType: PostEmptyType = .none
    
    // 게시글 리스트를 요청한다.
    func requestPosts(offset: Int = 0,
                      limit: Int = NBConstants.postLimitCount)
    {
        let provider = NetworkManager.shared.getProvider(PostsService.self)
        provider.request(.posts(id: boardId,
                                offset: offset,
                                limit: limit)
        ) { result in
            switch result {
            case .success(let response):
                print("request url : \(response.request?.url?.absoluteString ?? "")")
                print("code: \(response.statusCode)")
                let posts = try! JSONDecoder().decode(Posts.self, from: response.data)
                self.postsSuccess(posts, offset: offset)
            case .failure(let error):
                print("error posts: \(error)")
            }
        }
    }
    
    // 게시글 리스트 성공 처리
    private func postsSuccess(_ posts: Posts, offset: Int) {
        let count = posts.count ?? 0
        if count < NBConstants.postLimitCount {
            self.currOffset = -1 // -1인 경우 마지막 포스트로 다음 포스트를 요청하지 않도록 한다.
        } else {
            self.currOffset = offset + count // 다음 페이지 요청시 오프셋 설정
        }
        
        if let datas = posts.value {
            if self.currOffset == 0 {
                // 첫 페이지
                self.datas.accept(datas)
            } else {
                // 2페이지 보다 크거나 같은 경우 데이터를 추가한다.
                var totalDatas = self.datas.value
                totalDatas.append(contentsOf: datas)
                self.datas.accept(totalDatas)
            }
        }
    }
    
    // 마지막 페이지가 아닌 경우 다음 페이지 게시글 리스트 요청한다.
    func requestPostsNext() -> Bool {
        // 마지막 페이지가 아닌 경우
        if currOffset >= 0 {
            currOffset = currOffset + 1
            requestPosts(offset: currOffset)
            return true
        }
        return false
    }
    
    // 검색 리스트 요청한다.
    func requestSearch(target: String,
                       word: String,
                       offset: Int = 0,
                       limit: Int = 0,
                       next: Bool = false)
    {
        if !next {
            removeSearchs()
        }
        
        let provider = NetworkManager.shared.getProvider(PostsService.self)
        print("- id: \(boardId)\n- target: \(target)\n- word: \(word)\n- offset: \(offset)\n- limit: \(limit)")
        provider.request(.search(id: boardId,
                                 search: word,
                                 target: getSearchTarget(target),
                                 offset: offset,
                                 limit: limit)
        ) { result in
            switch result {
            case .success(let response):
                print("request url : \(response.request?.url?.absoluteString ?? "")")
                print("code: \(response.statusCode)")
                let posts = try! JSONDecoder().decode(Posts.self, from: response.data)
                self.searchMode.accept(.search)
                self.searchSuccess(posts,
                                   word: word,
                                   target: target,
                                   offset: offset
                )
            case .failure(let error):
                print("error searchs: \(error)")
            }
        }
    }
    
    // 검색 리스트 응답 성공 처리
    private func searchSuccess(_ posts: Posts,
                               word: String,
                               target: String,
                               offset: Int)
    {
        self.searchWord = word
        self.searchTarget = target
        
        if !DBManager.shared.isExistRecentItem(target: target, word: word) {
            // 로컬 db에 최근 검색 아이템을 저장한다.
            DBManager.shared.addRecentItem(item: .init(target: target, word: word)) {
                self.resetRecentItems()
            }
        }
        
        if searchMode.value == .search {
            if let datas = posts.value {
                self.searchDatas.accept(datas)
            }
        }
    }
    
    // 서버 요청시 영문 target 이름을 반환한다.
    private func getSearchTarget(_ target: String) -> String {
        let targets: [String: String] = [
            "전체": "all",
            "제목": "title",
            "내용": "contents",
            "작성자": "writer"
        ]
        var searchTarget = targets["전체"] ?? ""
        if let item = targets.first(where: { $0.key == target }) {
            searchTarget = item.value
        }
        return searchTarget
    }
}

extension PostsViewModel {
    // MARK: - Posts
    func getPosts() -> [PostsValue] {
        return datas.value
    }
    
    func isEmptyPost() -> Bool {
        return (getPosts().count == 0)
    }
    
    func getEmptyType() -> PostEmptyType {
        return emptyType
    }
    
    // MARK: - Search
    func getSearchs() -> [PostsValue] {
        return searchDatas.value
    }
    
    func removeSearchs() {
        searchDatas.accept([])
    }
    
    func getRecents() -> [RecentItem] {
        return searchRecentDatas.value
    }
    
    func isEmptySearch() -> Bool {
        if searchMode.value == .recent {
            return (getRecents().count == 0)
        } else if searchMode.value == .search {
            return (getSearchs().count == 0)
        }
        return false
    }
    
    // 최근 검색 데이터를 DB의 데이터로 갱신한다.
    func resetRecentItems() {
        searchRecentDatas.accept(DBManager.shared.getRecentItems())
    }
    
    // searchMode 별 리스트가 없을 경우 type값을 emptyType에 설정한다.
    func resetEmptyType() {
        let mode = searchMode.value
        if mode == .recent || mode == .input {
            emptyType = .searchDesc
        } else if mode == .search {
            emptyType = .searchEmpty
        } else {
            if isEmptyPost() {
                emptyType = .postEmpty
            } else {
                emptyType = .none
            }
        }
    }
}
