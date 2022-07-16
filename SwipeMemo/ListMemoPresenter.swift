//
//  ListMemoPresenter.swift
//  SwipeMemo
//
//  Created by 優也田島 on 2022/07/09.
//

import UIKit
import RealmSwift

protocol ListMemoPresenterInput {
    func didTapDeleteButton(forRow row: Int, indexPath: IndexPath)
    func didSwipeLeft()
    var numberOfMemos: Int { get }
    func memo(forRow row:Int) -> Memo
    func viewWillAppear()
    func pullDown()
}

protocol ListMemoPresenterOutput: AnyObject {
    func deleteMemo(indexPath:IndexPath)
    func reloadMemo()
    func transitionToCreate()
    func transitionToSettings()
}

final class ListMemoPresenter: ListMemoPresenterInput {
    
    private weak var view: ListMemoPresenterOutput!
    private var model: ListMemoModelInput
    
    private var memos: [Memo] = []
    
    var numberOfMemos: Int {
        return memos.count
    }

    init(view: ListMemoPresenterOutput, model: ListMemoModelInput) {
        self.view  = view
        self.model = model
    }
    
    func memo(forRow row: Int) -> Memo {
        return memos[row]
    }
    
    private func fetchMemo() {
        do {
            try memos = self.model.fetchAll()
        } catch StorageError.write(let message) {
            MemoError.pushErrorMessage(message: message)
        } catch {
            fatalError("Unexpected error: \(error).")
        }
    }
    
    func viewWillAppear() {
        fetchMemo()
        view.reloadMemo()
    }
    
    func pullDown() {
        view.transitionToCreate()
    }

    func didTapDeleteButton(forRow row: Int, indexPath at: IndexPath) {
        let memo = memo(forRow: row)
        do {
            try self.model.delete(memo: memo)
            fetchMemo()
            self.view.deleteMemo(indexPath: at)
        } catch StorageError.write(let message) {
            MemoError.pushErrorMessage(message: message)
        } catch {
            fatalError("Unexpected error: \(error).")
        }
    }

    func didSwipeLeft() {
        view.transitionToSettings()
    }
}
