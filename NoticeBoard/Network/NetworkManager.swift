//
//  NetworkManager.swift
//  NoticeBoard
//
//  Created by 김형진 on 2023/10/27.
//

import UIKit
import Moya

/**
 네트워크 공통 관리
 */
final class NetworkManager {
    static let shared = NetworkManager()
    
    // host url 객체 반환
    func getUrl() -> URL {
        guard let url = URL(string: UserDefaultManager.shared.getHostUrl()) else {
            fatalError("Not found host url")
        }
        return url
    }
    
    // Moya Prrovider를 생성 반환
    func getProvider<T>(_ type: T.Type) -> MoyaProvider<T> {
        // [중요] Moya 문서 가이드와 다른 동작함.
        // - AccessTokenPlugin을 넣어서 보내면 서버에서 오류 상태(400)를 반환한다.
//        let authPlugin = AccessTokenPlugin { _ in
//            return NBServer.bearer
//        }
//        let provider = MoyaProvider<T>(plugins: [authPlugin])
//        return provider
        return MoyaProvider<T>()
    }
}
