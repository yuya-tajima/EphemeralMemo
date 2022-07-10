//
//  CreateMemoModel.swift
//  EphemeralMemo
//
//  Created by 優也田島 on 2022/07/10.
//

import RealmSwift

protocol CreateMemoModelInput {
    func save(text: String)
}

struct CreateMemoModel: CreateMemoModelInput {
    
    private let realm = try! Realm()
    
    func save(text: String) {
        try! realm.write {
            let memo = Memo()
            memo.text = text
            memo.date = Date()
            realm.add(memo, update: .modified)
        }
    }
}
