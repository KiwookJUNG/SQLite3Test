//
//  ViewController.swift
//  SQLite3Test
//
//  Created by 정기욱 on 22/02/2019.
//  Copyright © 2019 Kiwook. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        var db: OpaquePointer? = nil // SQLite 연결 정보를 담을 객체
        var stmt: OpaquePointer? = nil // 컴파일된 SQL을 담을 객체
        
        // 앱 내 문서 디렉터리 경로에서 SQLite DB 파일을 찾는다.
        let fileMgr = FileManager() // 1. 파일매니저 객체를 생성함
        
        let docPathURL = fileMgr.urls(for: .documentDirectory, in: .userDomainMask).first!
        // 2. 생성된 매니저 객체를 사용하여 앱 내의 문서 디렉터리 경로를 찾고, 이를 URL 객체로 생성한다.
        
        let dbPath = docPathURL.appendingPathComponent("db.sqlite").path
        // URL 객체에 "db.sqlite" 파일 경로를 추가한 SQLite3 데이터 베이스 경로를 만들어낸다.
    
    }


}

