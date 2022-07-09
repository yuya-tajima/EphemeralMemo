//
//  EditViewController.swift
//  EphemeralMemo
//
//  Created by 優也田島 on 2022/07/09.
//

import UIKit
import RealmSwift

protocol DismissActionProtocol {
    func viewWillDismiss()
}

class EditViewController: UIViewController {
    
    var delegate: DismissActionProtocol?
    
    @IBOutlet weak var textField: UITextView!
    
    var memo: Memo!
    
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        textField.text = memo.contents
        
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.textContainerInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        textField.delegate = self
        
        presentationController?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if let text = self.textField.text, !text.isEmpty {
            try! realm.write {
                memo.contents = text
                self.realm.add(memo, update: .modified)
            }
        }
        
        super.viewWillDisappear(true)
    }
}

extension EditViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let maxWordsNumber = 150
        let maxLinesNumber = 10
        
        let totalWordCount    = textView.text.count + (text.count - range.length)
        
        let currentLineCount  = textView.text.components(separatedBy: .newlines).count
        let newLineCount      = text.components(separatedBy: .newlines).count - 1
        let totalLineCount    = currentLineCount + newLineCount
        
        return (totalWordCount <= maxWordsNumber) && (totalLineCount <= maxLinesNumber)
    }
}

extension EditViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        delegate?.viewWillDismiss()
    }
}
