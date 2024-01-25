# NoticeBoard

![image](https://github.com/leojini/NoticeBoard/assets/17540345/aef7f0a4-a676-480b-b017-8d899716d409)

![image](https://github.com/leojini/NoticeBoard/assets/17540345/265e2a36-bb97-44b7-8905-3cffbc064ea6)

1. 언어: Swift
   
2. 오픈 소스: SPM(Swift Package Manager) 종속성 관리 툴 사용
  - Moya(+Almofire): 네트워크 처리
  - Realm: Local 데이터 베이스
  - IQKeyboardManager: 키보드 제어
  - RxSwift: 비동기 처리
  - SnapKit: UI 레이아웃 설정
 
3. 디렉토리 분류
  - Common: 공통으로 사용하는 파일 관리(Constants.swift: 공통 상수 관리)
  - Domain: 네트워크 모델, 네트워크 연결 서비스 관련 파일 관리(Moya 라이브러리 사용)
  - DB: Local 데이터베이스 관련 파일, DB 매니저 파일 관리(Realm, UserDefault 사용)
  - Network: 네트워크 매니저 파일 관리(네트워크 공통 로직)
  - UI: Extension, 뷰 컨트롤러, 뷰 모델, 뷰 파일 관리
  
4. UI
  - Extension: 뷰 공통으로 쓰이는 로직 처리
  - Main: 앱 시작시 뷰 컨트롤러 및 뷰 모델
  - Boards: 게시판 관련 뷰 컨트롤러 및 뷰 모델, 뷰
  - Posts: 게시글, 검색 관련 뷰 컨트롤러 및 뷰 모델, 뷰 

5. UI 플로우 관련 파일
  - 앱 시작: MainViewController.swift(게시판으로 이동 버튼, 검색 내역 삭제 버튼)
  - 게시판 목록: BoardsViewContoller.swift
  - 게시글 목록, 검색 목록: PostsViewContoller.swift  

