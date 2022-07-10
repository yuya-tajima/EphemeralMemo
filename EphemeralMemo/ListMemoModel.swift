//
//  ListMemoModel.swift
//  EphemeralMemo
//
//  Created by 優也田島 on 2022/07/09.
//

import RealmSwift

protocol ListMemoModelInput {
    func delete(memo: Memo, completion: () -> ())
    func fetchAll() -> Results<Memo>
}

struct ListMemoModel: ListMemoModelInput {
    
    private let realm = try! Realm()
    
    func fetchAll () -> Results<Memo> {
        return realm.objects(Memo.self).sorted(byKeyPath: "date", ascending: false)
    }
    
    func delete(memo: Memo, completion: () -> ()) {
        try! realm.write {
            self.realm.delete(memo)
            completion()
        }
    }
}

