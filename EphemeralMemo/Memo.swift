//
//  Memo.swift
//  EphemeralMemo
//
//  Created by 優也田島 on 2022/07/05.
//

import RealmSwift

class Memo: Object {

    @Persisted(primaryKey: true) var id: ObjectId
    
    @Persisted var contents = ""
    
    @Persisted var date = Date()
}
