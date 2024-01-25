//
//  UserDefaultManager.swift
//  NoticeBoard
//
//  Created by 김형진 on 2023/10/30.
//

import Foundation

/**
 UserDefault 관련 공통 처리
 */
class UserDefaultManager {
    static let shared = UserDefaultManager()
    
    func setValue(key: String, value: String) {
        UserDefaults.standard.setValue(value, forKey: key)
    }
    
    func getValue(key: String) -> String {
        if let value: String = UserDefaults.standard.value(forKey: key) as? String {
            return value
        }
        return ""
    }
    
    func remove(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
}

extension UserDefaultManager {
    // 최초 시작시 startApp값을 1로 설정
    func setStartApp() {
        self.setValue(key: NBConstants.startApp, value: "1")
    }
    
    // 최초 시작시 했을 경우 true 반환
    func isStartApp() -> Bool {
        let startApp = self.getValue(key: NBConstants.startApp)
        if startApp == "1" {
            return true
        }
        return false
    }
    
    // 최초 시작 값 제거
    func removeStartApp() {
        self.remove(key: NBConstants.startApp)
    }
    
    func setHostUrl(url: String) {
        self.setValue(key: NBConstants.hostUrl, value: url)
    }
    
    func getHostUrl() -> String {
        return self.getValue(key: NBConstants.hostUrl)
    }
}
