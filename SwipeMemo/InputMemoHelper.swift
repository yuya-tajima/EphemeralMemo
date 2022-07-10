//
//  InputMemoHelper.swift
//  SwipeMemo
//
//  Created by 優也田島 on 2022/07/09.
//

protocol InputMemoConstraintsProtocol {
    func isNumberOfCharsCorrent(totalWordCount: Int, totalLineCount: Int) -> Bool
}

struct InputMemoHelper: InputMemoConstraintsProtocol {
    
    let maxWordsNumber = 150
    let maxLinesNumber = 10
    
    func isNumberOfCharsCorrent(totalWordCount: Int, totalLineCount: Int) -> Bool {
        return (totalWordCount <= maxWordsNumber) && (totalLineCount <= maxLinesNumber)
    }
}
