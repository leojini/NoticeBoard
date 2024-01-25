//
//  Constants.swift
//  NoticeBoard
//
//  Created by 김형진 on 2023/10/27.
//

import UIKit

/**
 서버 관련 공통 정의
 */
class NBServer {
    static let shared = NBServer()
    
    static let bearer: String = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE2ODgxMDM5NDAsImV4cCI6MCwidXNlcm5hbWUiOiJtYWlsdGVzdEBtcC1kZXYubXlwbHVnLmtyIiwiYXBpX2tleSI6IiMhQG1wLWRldiFAIyIsInNjb3BlIjpbImVhcyJdLCJqdGkiOiI5MmQwIn0.Vzj93Ak3OQxze_Zic-CRbnwik7ZWQnkK6c83No_M780"
    static let commonHeaders: [String : String] = ["Content-Type": "application/json",
                                                   "Authorization": NBServer.bearer
                                           ]
}

/**
 색상 관련 공통 정의
 */
class NBColor {
    // blackChocolate
    static let blackCl: UIColor = .init(hex: "241E17")
    static let boarder: UIColor = .init(hex: "F2F2F2")
    static let coolGrey: UIColor = .init(hex: "9E9E9E")
    static let coolGrey2: UIColor = .init(hex: "757575")
    static let coolGrey3: UIColor = .init(hex: "F7F7F7")
    static let orange: UIColor = .init(hex: "FF6412")
}

/**
 기타 상수값 정의
 */
class NBConstants {
    // 게시글 limit
    static let postLimitCount = 30
    // 앱 시작 키
    static let startApp = "startApp"
    // 호스트 url
    static let hostUrl = "hostUrl"
}

/**
 Notificatoin 이름 정의
 */
extension NSNotification.Name {
    // MainView 보여줄 때 boardViewController을 보여줄지 유무 설정
    static let showBoardVC = NSNotification.Name("showBoardVC")
}
