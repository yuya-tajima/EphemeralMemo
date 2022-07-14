//
//  EditMemoModel.swift
//  SwipeMemo
//
//  Created by 優也田島 on 2022/07/10.
//

import RealmSwift

protocol EditMemoModelInput {
    func save(memo: Memo, text: String) throws -> Void
}

struct EditMemoModel: EditMemoModelInput {
    
    func save(memo: Memo, text: String) throws -> Void {
        do {
            let realm = try Realm()

            try realm.write {
                memo.text = text
                realm.add(memo, update: .modified)
            }
            
        } catch let error as NSError {
            print(error.localizedDescription)
            throw StorageError.write("Not enough disk space for editing")
        }
    }
}
