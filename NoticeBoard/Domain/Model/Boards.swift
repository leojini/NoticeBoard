//
//  Boards.swift
//  NoticeBoard
//
//  Created by 김형진 on 2023/10/26.
//

import Foundation

/**
 게시판 관련 데이터 정의
 */
struct Boards: Codable {
    let value: [BoardsValue]?
    let count: Int?
    let offset: Int?
    let limit: Int?
    let total: Int?
}

struct BoardsValue: Codable {
    let boardId: Int
    let displayName: String
    let boardType: String
    let isFavorite: Bool
    let hasNewPost: Bool
    let orderNo: Int
    let capability: BoardsValueCapability
}

struct BoardsValueCapability: Codable {
    let writable: Bool
    let manageable: Bool
}
