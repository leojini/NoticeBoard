//
//  BoardsViewModel.swift
//  NoticeBoard
//
//  Created by 김형진 on 2023/10/27.
//

import Foundation
import RxSwift
import RxRelay
import Moya

/**
 게시판 뷰 모델
 */
class BoardsViewModel {
    private lazy var disposeBag = DisposeBag()
    
    // 게시판 데이터 저장
    let boards = BehaviorRelay<Boards?>(value: nil)
    
    func request() {
        let provider = NetworkManager.shared.getProvider(BoardsService.self)
        provider.request(.boards) { result in
            switch result {
            case .success(let response):
                print("code: \(response.statusCode)")
                do {
                    let boards = try JSONDecoder().decode(Boards.self, from: response.data)
                    self.boards.accept(boards)
                } catch {
                    print("error boards: \(error)")
                }
            case .failure(let error):
                print("error boards: \(error)")
            }
        }
    }
    
    // 게시판 데이터 반환
    func getBoards() -> [BoardsValue] {
        if let boards = boards.value {
            return boards.value ?? []
        }
        return []
    }
}
