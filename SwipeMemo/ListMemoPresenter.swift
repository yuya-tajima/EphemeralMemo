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
    var numberOfMemos: Int { get }
    func memo(forRow row:Int) -> Memo?
    mutating func viewDidLoad()
    func viewWillAppear()
}

protocol ListMemoPresenterOutput: AnyObject {
    func deleteMemo(indexPath:IndexPath)
    func reloadMemo()
}

struct ListMemoPresenter: ListMemoPresenterInput {
    
    private weak var view: ListMemoPresenterOutput!
    private var model: ListMemoModelInput
    
    private var memos: Results<Memo>? = nil
    
    var numberOfMemos: Int {
        return memos!.count
    }
    
    init(view: ListMemoPresenterOutput, model: ListMemoModelInput) {
        self.view  = view
        self.model = model
    }
    
    func memo(forRow row: Int) -> Memo? {
        return memos?[row]
    }
    
    mutating func viewDidLoad() {
        memos = self.model.fetchAll()
    }
    
    func viewWillAppear() {
        view.reloadMemo()
    }
    
    func didTapDeleteButton(forRow row: Int, indexPath at: IndexPath) {
        if let memo = memo(forRow: row) {
            self.model.delete(memo: memo) { () in
                self.view.deleteMemo(indexPath: at)
            }
        }
    }
}
