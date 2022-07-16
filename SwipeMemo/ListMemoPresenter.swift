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
    func memo(forRow row:Int) -> Memo?
    mutating func viewDidLoad()
    func viewWillAppear()
    func pullDown()
}

protocol ListMemoPresenterOutput: AnyObject {
    func deleteMemo(indexPath:IndexPath)
    func reloadMemo()
    func transitionToCreate()
    func transitionToSettings()
}

struct ListMemoPresenter: ListMemoPresenterInput {
    
    private weak var view: ListMemoPresenterOutput!
    private var model: ListMemoModelInput
    
    private var memos: Results<Memo>? = nil
    
    var numberOfMemos: Int {
        return memos?.count ?? 0
    }

    init(view: ListMemoPresenterOutput, model: ListMemoModelInput) {
        self.view  = view
        self.model = model
    }
    
    func memo(forRow row: Int) -> Memo? {
        return memos?[row]
    }
    
    mutating func viewDidLoad() {
        do {
            try memos = self.model.fetchAll()
        } catch StorageError.write(let message) {
            MemoError.pushErrorMessage(message: message)
        } catch {
            fatalError("Unexpected error: \(error).")
        }
    }
    
    func viewWillAppear() {
        view.reloadMemo()
    }
    
    func pullDown() {
        view.transitionToCreate()
    }

    func didTapDeleteButton(forRow row: Int, indexPath at: IndexPath) {
        if let memo = memo(forRow: row) {
            do {
                try self.model.delete(memo: memo)
                self.view.deleteMemo(indexPath: at)
            } catch StorageError.write(let message) {
                MemoError.pushErrorMessage(message: message)
            } catch {
                fatalError("Unexpected error: \(error).")
            }
        }
    }

    func didSwipeLeft() {
        view.transitionToSettings()
    }
}
