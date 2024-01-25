//
//  DBManager.swift
//  NoticeBoard
//
//  Created by 김형진 on 2023/10/30.
//

import Foundation
import Realm
import RealmSwift

/**
 데이터베이스 추가, 삭제, 조회 관리
 */
class DBManager {
    static let shared = DBManager()
    
    let realm = try! Realm()
    
    // 최근 검색 아이템 추가
    func addRecentItem(item: RecentItem, complete: @escaping (() -> Void)) {
        try! realm.write ({
            realm.add(item)
            
            DispatchQueue.main.async {
                complete()
            }
        })
    }
    
    // target, word와 같은 최근 검색 아이템이 존재시 true 반환
    func isExistRecentItem(target: String, word: String) -> Bool {
        let items = realm.objects(RecentItem.self)
        let result = items.where {
            $0.target == target && $0.word == word
        }
        if result.count > 0 {
            return true
        }
        return false
    }
    
    // 최근 검색 아이템들을 반환하다.
    func getRecentItems(reverse: Bool = true) -> [RecentItem] {
        let items = realm.objects(RecentItem.self)
        
        var recentItems: [RecentItem] = []
        if reverse {
            // 추가한 반대 순서로 정렬
            for item in items.reversed() {
                recentItems.append(item)
            }
        } else {
            for item in items {
                recentItems.append(item)
            }
        }
        return recentItems
    }
    
    // 최근 검색 아이템에서 target, word와 같은 아이템을 삭제한다.
    func removeRecentItem(target: String, word: String, complete: @escaping (() -> Void)) {
        let items = realm.objects(RecentItem.self)
        let result = items.where {
            $0.target == target && $0.word == word
        }
        if result.count > 0 {
            let item = result[0]
            try! realm.write {
                realm.delete(item)
                complete()
            }
        }
    }
}
