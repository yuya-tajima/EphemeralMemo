//
//  EditMemoViewController.swift
//  EphemeralMemo
//
//  Created by 優也田島 on 2022/07/09.
//

import UIKit

class EditMemoViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextView!
    
    private var presenter: EditMemoPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func inject(presenter: EditMemoPresenter) {
        self.presenter = presenter
    }
    
    private func setup () {
        let memo = self.presenter.editingMemo
        textField.text = memo?.text
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.textContainerInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        textField.delegate = self
        
        presentationController?.delegate = self
    }
    
    func setEditingMemo (memo: Memo) {
        self.presenter.editingMemo = memo
    }
    
    func setPrevController (viewController: EditMemoDismissActionProtocol) {
        self.presenter.prevController = viewController
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let text = self.textField.text, !text.isEmpty {
            self.presenter.viewWillDisappear(text: text)
        }
        super.viewWillDisappear(true)
    }
}

extension EditMemoViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let totalWordCount    = textView.text.count + (text.count - range.length)
        let currentLineCount  = textView.text.components(separatedBy: .newlines).count
        let newLineCount      = text.components(separatedBy: .newlines).count - 1
        let totalLineCount    = currentLineCount + newLineCount
        
        return self.presenter.shouldChangeTextIn(totalWordCount: totalWordCount, totalLineCount: totalLineCount)
    }
}

extension EditMemoViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        presenter.dismiss()
    }
}

extension EditMemoViewController: EditMemoPresenterOutput {}
