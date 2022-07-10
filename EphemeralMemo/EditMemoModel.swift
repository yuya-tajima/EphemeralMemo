//
//  EditMemoModel.swift
//  EphemeralMemo
//
//  Created by 優也田島 on 2022/07/10.
//

import RealmSwift

protocol EditMemoModelInput {
    func save(memo: Memo, text: String)
}

struct EditMemoModel: EditMemoModelInput {
    
    private let realm = try! Realm()
    
    func save(memo: Memo, text: String) {
        try! realm.write {
            memo.text = text
            realm.add(memo, update: .modified)
        }
    }
}
