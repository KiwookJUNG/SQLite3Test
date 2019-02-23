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
        
        // FileManager()를 사용하지 않고 커스텀 프로퍼티 리스트를 다룰 때 사용했던
        // let path = NSSearchPathForDirectoriesInDomains(.documnetDirectory, .userDomainMasK, true)[0] as NSStirng
        // let dbPath = path.strings(byAppendingPaths: ["db.sqlite"])[0]
        // 와 동일하게 사용 할 수 있음.
        
        let sql = "CREATE TABLE IF NOT EXISTS sequence (num INTEGER)"
        // CREATE로 시작하는 구문은 데이터베이스 테이블을 정의하는 SQL 구문으로써 DDL에 해당한다.
        // 즉, sequence라는 이름의 테이블을 정의하라. 라는 뜻
        // 하나의 INTEGER 타입 칼럼을 가지며 칼럼명은 num
        // viewDidLoad는 앱이 재실행되거나, 화면이 다시 메모리에 로딩될 때 반복해서 호출되므로
        // IF NOT EXISTS를 사용하여 테이블이 없는 경우에만 새로 테이블을 생성하도록 처리해준다.
        
        // sqlite3 데이터베이스 관련 함수를 순서대로 호출한다.
        if sqlite3_open(dbPath, &db) == SQLITE_OK { // libsqlite3 라이브러리에 정의된 함수들은 정상적으로 실행되었을 때
        // 공통적으로 SQLITE_OK 상수를 반환한다.
        // DB를 연결, db객체 생성
        // 첫번째 인자, SQLite 파일의 경로, 두번째 인자 생성된 DB객체를 담을 변수
        // &db 참조 타입이 사용되는 이유는 OpaquePointer가 구조체 이기 떄문이다.
    
            if sqlite3_prepare(db, sql, -1, &stmt, nil) == SQLITE_OK {
            // SQL구문을 전달할 준비를 한다. 이 과정에서 컴파일된 SQL 구문 객체가 생성됨
            // stmt는 출력값 성격을 가지는 인자값, sql구문은 데이터베이스에 전달할 수 있는 sqltie3_stmt객체로 생성됨
        
        
            sqlite3_step(stmt) // 컴파일된 SQL 구문 객체를 db에 전달한다.
            // 생성된 객체를 stmt 인자값에 담아 전달한다
            // 생성된 stmt객체 안에는 컴파일된 SQL뿐만 아니라 DB연결 정보까지 포함되어있으므로, sqlite3 객체를 인자값으로
            // 전달할 필요 없다.
        
                if sqlite3_finalize(stmt) == SQLITE_DONE {
                   // 컴파일된 SQL 구문 객체를 삭제한다. 이 과정에서 stmt가 해제된다.
                   // SQL 실행이 끝나면 더 이상 사용하지 않는 자원, 즉 DB연결 객체와 SQL 컴파일 객체를 해제해 주어야함.
                   // 그래야 데이터베이스가 또 다른 연결 요청을 받을 수 있다.
                   // 자원을 해제 할때의 순서는 self.stmt -> self.db 순서로 해제한다.
                    print("Create Table Success!")
                    
                }
            } else {
                print("Prepare Statment Fail")
    
            }
        sqltie3_close(db)
        // DB연결을 종료한다. 이 과정에서 db객체가 해제됨.
        } else {
            print("Database Connect Fail")
            return
        }
    }


}

