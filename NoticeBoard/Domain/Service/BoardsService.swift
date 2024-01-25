//
//  BoardsService.swift
//  NoticeBoard
//
//  Created by 김형진 on 2023/10/26.
//

import Foundation
import Moya

/**
 게시판 관련 네트워크 정의
 */
enum BoardsService: TargetType, AccessTokenAuthorizable {
    // [GET] api/v2/boards
    case boards
}

extension BoardsService {
    var baseURL: URL {
        return NetworkManager.shared.getUrl()
    }
    
    var path: String {
        switch self {
        case .boards:
            return "/api/v2/boards"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .boards:
            return .get
        }
    }
    
    var simpleData: Data {
        switch self {
        case .boards:
            return Data()
        }
    }
    
    var task: Task {
        switch self {
        case .boards:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return NBServer.commonHeaders
    }
    
    var authorizationType: AuthorizationType? {
        switch self {
        case .boards:
            return .bearer
        }
    }
}
