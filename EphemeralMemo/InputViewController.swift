//
//  InputViewController.swift
//  EphemeralMemo
//
//  Created by 優也田島 on 2022/07/02.
//

import UIKit

class InputViewController: UIViewController {

    @IBOutlet weak var textField: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(true, animated: false)

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
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.textField.becomeFirstResponder()
    }

    @objc func didSwipe(_ sender: UISwipeGestureRecognizer) {

        switch sender.direction {
        case .left:

            let storyboardID = self.restorationIdentifier!

            let listViewController   = storyboard!.instantiateViewController(withIdentifier: "List")
            let firstViewController  = storyboard!.instantiateViewController(withIdentifier: "FirstInput")
            let sedondViewController = storyboard!.instantiateViewController(withIdentifier: "SecondInput")

            var controllerStack: [UIViewController] = [listViewController]

            if storyboardID == "FirstInput" {
                controllerStack += [firstViewController, sedondViewController]
            } else {
                controllerStack += [sedondViewController, firstViewController]
            }

            self.navigationController?.setViewControllers(controllerStack, animated: true)

        case .down:
            self.navigationController?.popToRootViewController(animated: true)
        default:
            break
        }
    }
}
