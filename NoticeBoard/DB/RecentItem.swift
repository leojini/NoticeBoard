//
//  RecentItem.swift
//  NoticeBoard
//
//  Created by 김형진 on 2023/10/29.
//

import Foundation
import Realm
import RealmSwift

/**
 최근 검색한 아이템 저장 클래스. Realm을 사용해서 저장, 조회, 삭제한다.
 */
class RecentItem: Object {
    @Persisted var target: String
    @Persisted var word: String
    
    convenience init(target: String, word: String) {
        self.init()
        self.target = target
        self.word = word
    }
}
