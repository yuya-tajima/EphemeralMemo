//
//  ListMemoModel.swift
//  SwipeMemo
//
//  Created by 優也田島 on 2022/07/09.
//

import RealmSwift

protocol ListMemoModelInput {
    func delete(memo: Memo) throws -> Void
    func fetchAll() throws -> Results<Memo>
}

struct ListMemoModel: ListMemoModelInput {
    
    func fetchAll () throws -> Results<Memo> {
        do {
            let realm = try Realm()
            return realm.objects(Memo.self).sorted(byKeyPath: "date", ascending: false)
        } catch let error as NSError {
            print(error.localizedDescription)
            throw StorageError.unknown("An unexpected error has occurred.")
        }
    }
    
    func delete(memo: Memo) throws -> Void {
        do {
            let realm = try Realm()

            try realm.write {
                realm.delete(memo)
            }

        } catch let error as NSError {
            print(error.localizedDescription)
            throw StorageError.write("The selected data could not be deleted")
        }
    }
}
