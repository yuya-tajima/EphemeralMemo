//
//  SettingsViewController.swift
//  SwipeMemo
//
//  Created by 優也田島 on 2022/07/16.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        
        versionLabel.text = "1.0"
        
        let downSwipe = UISwipeGestureRecognizer(
            target: self,
            action: #selector(self.didSwipe(_:))
        )
        downSwipe.direction = .down
        self.view.addGestureRecognizer(downSwipe)
    }

    @objc func didSwipe(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .down:
            let transition:CATransition = CATransition()
            transition.duration = 0.25
            transition.type = .push
            transition.subtype = .fromTop
            self.navigationController?.view.layer.add(transition, forKey: kCATransition)
            self.navigationController?.popViewController(animated: false)
        default:
            break
        }
    }
}
