//
//  SettingsUIStoryboardSegue.swift
//  SwipeMemo
//
//  Created by 優也田島 on 2022/07/16.
//

import UIKit

class SettingsUIStoryboardSegue: UIStoryboardSegue {
    override func perform()
    {
        let src: UIViewController = self.source
        let dst: UIViewController = self.destination
        let transition: CATransition = CATransition()
        let timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.duration = 0.25
        transition.timingFunction = timeFunc
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        src.navigationController?.view.layer.add(transition, forKey: kCATransition)
        src.navigationController?.pushViewController(dst, animated: false)
    }
}
