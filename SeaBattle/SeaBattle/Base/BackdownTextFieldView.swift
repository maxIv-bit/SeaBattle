//
//  BackdownTextFieldView.swift
//  SeaBattle
//
//  Created by Maks on 19.11.2020.
//

import UIKit

final class BackdownTextFieldView: UITextField {
    var backdown = CGFloat.zero
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        CGRect(center: bounds.center, size: CGSize(width: bounds.width - backdown, height: bounds.height))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        CGRect(center: bounds.center, size: CGSize(width: bounds.width - backdown, height: bounds.height))
    }
}
