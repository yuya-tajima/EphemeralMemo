//
//  EditMemoPresenter.swift
//  EphemeralMemo
//
//  Created by 優也田島 on 2022/07/10.
//

protocol EditMemoPresenterInput {
    func shouldChangeTextIn (totalWordCount words: Int, totalLineCount lines: Int) -> Bool
    func viewWillDisappear(text: String)
    var editingMemo: Memo! {get set}
    func dismiss()
}

protocol EditMemoDismissActionProtocol {
    func viewWillAppear()
}

protocol EditMemoPresenterOutput: AnyObject {}

struct EditMemoPresenter: EditMemoPresenterInput {
    
    var prevController: EditMemoDismissActionProtocol!

    private weak var view: EditMemoPresenterOutput!
    private var model: EditMemoModelInput
    private var helper: InputMemoConstraintsProtocol
    
    var editingMemo: Memo!
    
    init(view: EditMemoPresenterOutput, model: EditMemoModelInput, helper: InputMemoConstraintsProtocol) {
        self.view  = view
        self.model = model
        self.helper = helper
    }
    
    func dismiss() {
        prevController.viewWillAppear()
    }
    
    func shouldChangeTextIn (totalWordCount words: Int, totalLineCount lines: Int) -> Bool {
        return self.helper.isNumberOfCharsCorrent(totalWordCount: words, totalLineCount: lines)
    }
    
    func viewWillDisappear(text: String) {
        self.model.save(memo: editingMemo, text: text)
    }
}
