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
//        var db: OpaquePointer? = nil // SQLite 연결 정보를 담을 객체
//        var stmt: OpaquePointer? = nil // 컴파일된 SQL을 담을 객체
//
//        // 앱 내 문서 디렉터리 경로에서 SQLite DB 파일을 찾는다.
//        let fileMgr = FileManager() // 1. 파일매니저 객체를 생성함
//
//        let docPathURL = fileMgr.urls(for: .documentDirectory, in: .userDomainMask).first!
//        // 2. 생성된 매니저 객체를 사용하여 앱 내의 문서 디렉터리 경로를 찾고, 이를 URL 객체로 생성한다.
//
//        let dbPath = try! docPathURL.appendingPathComponent("db.sqlite").path
//        // URL 객체에 "db.sqlite" 파일 경로를 추가한 SQLite3 데이터 베이스 경로를 만들어낸다.
//
//        // FileManager()를 사용하지 않고 커스텀 프로퍼티 리스트를 다룰 때 사용했던
//        // let path = NSSearchPathForDirectoriesInDomains(.documnetDirectory, .userDomainMasK, true)[0] as NSStirng
//        // let dbPath = path.strings(byAppendingPaths: ["db.sqlite"])[0]
//        // 와 동일하게 사용 할 수 있음.
//
//        if fileMgr.fileExists(atPath: dbPath) == false { // dbPath 경로에 파일이 잇는지 없는지 체크한다.
//            // dbPath 경로에 파일이 없는 경우는 처음 접속했을 때 뿐이다.
//            // sqlite3_open 함수를 실행하고 나면 데이터베이스 파일이 없을 경우 새로 생성되기 때문에
//            // dbPath 경로에 파일이 없다는 것은 아직 sqlite3_open() 함수가 한 번도 호출되지 않은 최초의 접속이라고
//            // 판단할 수 있다. 이때 기본적인 테이블 구조가 만들어져 있는 db.sqlite 파일을 복사해 주면 이미 만들어진 테이블을
//            // 바로 사용할 수 있다.
//
//            // 만약 파일이 없다면 앱 번들에 포함된 db.sqlite 파일의 경로를 읽어온다.
//            let dbSource = Bundle.main.path(forResource: "db", ofType: "sqlite")
//            // 번들 파일 경로에 있는 db.sqlite 파일을 dbPath 경로에 복사한다.
//            try! fileMgr.copyItem(atPath: dbSource!, toPath: dbPath)
//        }
//
        // 위의 코드를 리팩토링을 통한 함수로 짧게 만들어줌
        let dbPath = self.getDBPath()
        self.dbExecute(dbPath: dbPath)
        
        
        
//        // sqlite3 데이터베이스 관련 함수를 순서대로 호출한다.
//        if sqlite3_open(dbPath, &db) == SQLITE_OK { // libsqlite3 라이브러리에 정의된 함수들은 정상적으로 실행되었을 때
//        // 공통적으로 SQLITE_OK 상수를 반환한다.
//        // DB를 연결, db객체 생성
//        // 첫번째 인자, SQLite 파일의 경로, 두번째 인자 생성된 DB객체를 담을 변수
//        // &db 참조 타입이 사용되는 이유는 OpaquePointer가 구조체 이기 떄문이다.
//
//            if sqlite3_prepare(db, sql, -1, &stmt, nil) == SQLITE_OK {
//            // SQL구문을 전달할 준비를 한다. 이 과정에서 컴파일된 SQL 구문 객체가 생성됨
//            // stmt는 출력값 성격을 가지는 인자값, sql구문은 데이터베이스에 전달할 수 있는 sqltie3_stmt객체로 생성됨
//
//
//            sqlite3_step(stmt) // 컴파일된 SQL 구문 객체를 db에 전달한다.
//            // 생성된 객체를 stmt 인자값에 담아 전달한다
//            // 생성된 stmt객체 안에는 컴파일된 SQL뿐만 아니라 DB연결 정보까지 포함되어있으므로, sqlite3 객체를 인자값으로
//            // 전달할 필요 없다.
//
//                if sqlite3_finalize(stmt) == SQLITE_DONE {
//                   // 컴파일된 SQL 구문 객체를 삭제한다. 이 과정에서 stmt가 해제된다.
//                   // SQL 실행이 끝나면 더 이상 사용하지 않는 자원, 즉 DB연결 객체와 SQL 컴파일 객체를 해제해 주어야함.
//                   // 그래야 데이터베이스가 또 다른 연결 요청을 받을 수 있다.
//                   // 자원을 해제 할때의 순서는 self.stmt -> self.db 순서로 해제한다.
//                    print("Create Table Success!")
//
//                }
//            } else {
//                print("Prepare Statment Fail")
//
//            }
//        sqlite3_close(db)
//        // DB연결을 종료한다. 이 과정에서 db객체가 해제됨.
//        } else {
//            print("Database Connect Fail")
//            return
//        }
    }
    
    func dbExecute(dbPath: String) {
        var db : OpaquePointer? = nil // SQLite 연결 정보를 담을 변수
        
        guard sqlite3_open(dbPath, &db) == SQLITE_OK else {
            print("Database Connect Fail")
            return
        }
        
        // 데이터 베이스 연결 종료
        defer {
            print("Close Database Connection")
            sqlite3_close(db)
        }
        
        var stmt : OpaquePointer? = nil // 컴파일된 SQL 정보를 담을 변수
        let sql = "CREATE TABLE IF NOT EXISTS sequence (num INTEGER)"
        
        guard sqlite3_prepare(db, sql, -1, &stmt, nil) == SQLITE_OK else {
            print("Prepare Statement Fail")
            return
        }
        
        // stmt 변수 해제
        defer {
            print("Finalize Statement")
            sqlite3_finalize(stmt)
        }
        
        
        if sqlite3_step(stmt) == SQLITE_DONE {
            print("Create Table Success!")
        }
        
        
//        var stmt : OpaquePointer? = nil // 컴파일된 SQL 정보를 담을 변수
//
//        let sql = "CREATE TABLE IF NOT EXISTS sequence (num INTEGER)"
//
//        if sqlite3_open(dbPath, &db) == SQLITE_OK { // SQLite 연결 정보를 담을 변수
//            if sqlite3_prepare(db, sqlite, -1, &stmt, nil) == SQLITE_OK {
//                // SQL 컴파일이 잘 끝났다면
//                if sqlite3_step(stmt) == SQLITE_DONE {
//                    print("Create Table Success!")
//                }
//                // 컴파일된 SQL 객체를 해제한다.
//                sqlite3_finalize(stmt)
//            } else {
//                print("Prepare Statment Fail")
//            }
//            // DB 연결을 해제한다.
//            sqlite3_close(db)
//        } else {
//            print("Database Connect Fail")
//            return
//        }
        
        
    }
    
    func getDBPath() -> String {
        // 앱 내 문서 디렉터리 경로에서 SQLite DB 파일을 찾는다.
        let fileMgr = FileManager()
        let docPathURL = fileMgr.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let dbPath = docPathURL.appendingPathComponent("db.sqlite").path
        
        // dbPath 경로에 db.sqlite 파일이 없다면 앱 번들에 만들어 둔 db.sqlite를 가져와 복사한다.
        if fileMgr.fileExists(atPath: dbPath) == false {
            let dbSource = Bundle.main.path(forResource: "db", ofType: "sqlite")
            try! fileMgr.copyItem(atPath: dbSource!, toPath: dbPath)
        }
        return dbPath
        
    }
    
    


}

