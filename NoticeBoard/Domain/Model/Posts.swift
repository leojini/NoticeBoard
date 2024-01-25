//
//  Posts.swift
//  NoticeBoard
//
//  Created by 김형진 on 2023/10/27.
//

import Foundation

/**
 게시글 관련 데이터 정의
 */
struct Posts: Codable {
    var value: [PostsValue]?
    let count: Int?
    let offset: Int?
    let limit: Int?
    let total: Int?
}

enum PostStyle {
    case normal
    case notice
    case reply
}

struct PostsValue: Codable {
    let postId: Int
    let title: String
    let boardId: Int
    let boardDisplayName: String
    let writer: PostWriter
    let contents: String
    let createdDateTime: String
    let viewCount: Int
    let postType: String
    let isNewPost: Bool
    let hasInlineImage: Bool
    let commentsCount: Int
    let attachmentsCount: Int
    let isAnonymous: Bool
    let isOwner: Bool
    let hasReply: Bool
    
    func getPostStyle() -> PostStyle {
        if postType == "normal" {
            return .normal
        } else if postType == "reply" {
            return .reply
        } else {
            return .notice
        }
    }
    
    func isNoticePostStyle() -> Bool {
        return getPostStyle() == .notice
    }
    
    func isReplyPostStyle() -> Bool {
        return getPostStyle() == .reply
    }
    
    func getDateTime() -> String {
        // 2023-07-05T06:50:00Z. ISO 8601
        // YY-MM-DD
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ssZ"
        formatter.timeZone = TimeZone(identifier: "UTC")
        if let date = formatter.date(from: createdDateTime) {
            let formatter2 = DateFormatter()
            formatter2.dateFormat = "YY-MM-dd"
            formatter2.timeZone = TimeZone(identifier: "UTC")
            return formatter2.string(from: date)
        }
        return createdDateTime
    }
}

struct PostWriter: Codable {
    let displayName: String
    let emailAddress: String
}
