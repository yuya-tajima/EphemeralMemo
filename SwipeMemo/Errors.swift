//
//  Errors.swift
//  SwipeMemo
//
//  Created by 優也田島 on 2022/07/14.
//

enum StorageError: Error {
    case write(String)
    case read(String)
    case unknown(String)
}

enum PresentationError: Error {
    case save(String)
}

struct MemoError {
    static private var message: String = ""
    
    static func exists () -> Bool {
        return !self.message.isEmpty
    }
    
    static func pushErrorMessage (message: String) {
        self.message = message
    }
    
    static func popErrorMessage () -> String {
        let message = self.message
        self.message = ""
        return message
    }
}
