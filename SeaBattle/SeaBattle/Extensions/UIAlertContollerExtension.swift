//
//  UIAlertContollerExtension.swift
//  SeaBattle
//
//  Created by Maks on 18.11.2020.
//

import UIKit

extension UIAlertController {
    public static func showOkAlert(title: String? = nil, message: String?, action: (() -> Void)? = nil, viewController: UIViewController?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { _ in
            action?()
        })
        alert.addAction(okAction)
        viewController?.present(alert, animated: true, completion: nil)
    }
}
