//
//  CreateMemoViewController.swift
//  EphemeralMemo
//
//  Created by 優也田島 on 2022/07/02.
//

import UIKit

class CreateMemoViewController: UIViewController {

    @IBOutlet weak var textField: UITextView!
    
    private var listViewController: ListMemoViewController!
    private var firstViewController: CreateMemoViewController!
    private var secondViewController: CreateMemoViewController!
    
    private var presenter: CreateMemoPresenterInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func inject(presenter: CreateMemoPresenterInput) {
        self.presenter = presenter
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.textField.becomeFirstResponder()
    }
    
    private func setup() {
        
        self.navigationController!.setNavigationBarHidden(true, animated: false)
        
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.textContainerInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        textField.delegate = self

        let leftSwipe = UISwipeGestureRecognizer(
            target: self,
            action: #selector(self.didSwipe(_:))
        )
        leftSwipe.direction = .left
        self.view.addGestureRecognizer(leftSwipe)

        let downSwipe = UISwipeGestureRecognizer(
            target: self,
            action: #selector(self.didSwipe(_:))
        )
        downSwipe.direction = .down
        self.view.addGestureRecognizer(downSwipe)
        
        let model = CreateMemoModel()
        let helper = InputMemoHelper()

        listViewController = storyboard!.instantiateViewController(withIdentifier: "List") as? ListMemoViewController
        listViewController.inject(
            presenter: ListMemoPresenter(
                view: listViewController,
                model: ListMemoModel()
            )
        )
        
        firstViewController = storyboard!.instantiateViewController(withIdentifier: "FirstInput") as? CreateMemoViewController
        firstViewController.inject(
            presenter: CreateMemoPresenter(
                view: firstViewController,
                model: model,
                helper: helper
            )
        )
        
        secondViewController = storyboard!.instantiateViewController(withIdentifier: "SecondInput") as? CreateMemoViewController
        secondViewController.inject(
            presenter: CreateMemoPresenter(
                view: secondViewController,
                model: model,
                helper: helper
            )
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let text = self.textField.text, !text.isEmpty {
            self.presenter.viewWillDisappear(text: text)
        }
        super.viewWillDisappear(true)
    }
    
    @objc func didSwipe(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .left:
            let storyboardID = self.restorationIdentifier!
            presenter.didLeftSwipe(storyboardID: storyboardID)
        case .down:
            presenter.didDownSwipe()
        default:
            break
        }
    }
}

extension CreateMemoViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let totalWordCount    = textView.text.count + (text.count - range.length)
        let currentLineCount  = textView.text.components(separatedBy: .newlines).count
        let newLineCount      = text.components(separatedBy: .newlines).count - 1
        let totalLineCount    = currentLineCount + newLineCount
        
        return self.presenter.shouldChangeTextIn(totalWordCount: totalWordCount, totalLineCount: totalLineCount)
    }
}

extension CreateMemoViewController: CreateMemoPresenterOutput {
    
    func transitionToNextInput(storyboardID: String) {
        var controllerStack: [UIViewController] = [listViewController]
        
        if storyboardID == "FirstInput" {
            controllerStack += [firstViewController, secondViewController]
        } else {
            controllerStack += [secondViewController, firstViewController]
        }
        
        let transition:CATransition = CATransition()
        transition.duration = 0.1
        transition.type = .push
        transition.subtype = .fromRight
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        self.navigationController!.setViewControllers(controllerStack, animated: false)
    }
    
    func transitionToList() {
        let controllerStack: [UIViewController] = [listViewController]
        let transition:CATransition = CATransition()
        transition.duration = 0.1
        transition.type = .push
        transition.subtype = .fromTop
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        self.navigationController!.setViewControllers(controllerStack, animated: false)
    }
}
