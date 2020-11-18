//
//  UIViewControllerExtension.swift
//  SeaBattle
//
//  Created by Maks on 18.11.2020.
//

import UIKit

extension UIViewController {
    public static func pvc() -> UIViewController? {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        } else {
            return nil
        }
    }
}
