//
//  PostsService.swift
//  NoticeBoard
//
//  Created by 김형진 on 2023/10/27.
//

import Foundation
import Moya

/**
 게시글 관련 네트워크 정의
 */
enum PostsService: TargetType, AccessTokenAuthorizable {
    // [GET] api/v2/boards/{boards_id}/posts?offset=0&limit=30
    case posts(id: Int, offset: Int, limit: Int)
    
    // [GET] api/v2/boards/{board_id}/posts?search=&searchTarget=&offset=&limit=
    case search(id: Int, search: String, target: String, offset: Int, limit: Int)
}

extension PostsService {
    var baseURL: URL {
        return NetworkManager.shared.getUrl()
    }
    
    var path: String {
        switch self {
        case .posts(let id, _, _):
            return "/api/v2/boards/\(id)/posts"
        case .search(let id, _, _, _, _):
            return "/api/v2/boards/\(id)/posts"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .posts:
            return .get
        case .search:
            return .get
        }
    }
    
    var simpleData: Data {
        switch self {
        case .posts:
            return Data()
        case .search:
            return Data()
        }
    }
    
    var task: Task {
        switch self {
        case .posts(_, let offset, let limit):
            return .requestParameters(parameters:
                                        ["offset": "\(offset)",
                                         "limit": "\(limit)"
                                        ],
                                      encoding: URLEncoding.default)
        case .search(_, let search, let target, let offset, let limit):
            return .requestParameters(parameters:
                                        ["search": "\(search)",
                                         "searchTarget": "\(target)",
                                         "offset": "\(offset)",
                                         "limit": "\(limit)"
                                        ],
                                      encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return NBServer.commonHeaders
    }
    
    var authorizationType: AuthorizationType? {
        switch self {
        case .posts:
            return .bearer
        case .search:
            return .bearer
        }
    }
}

