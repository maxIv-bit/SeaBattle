//
//  RotateHintViewModel.swift
//  SeaBattle
//
//  Created by Maks on 17.12.2020.
//

import Foundation
import UIKit

final class RotateHintViewModel: BaseViewModel {
    private(set) var boatFrame: CGRect
    
    init(boatFrame: CGRect) {
        self.boatFrame = boatFrame
    }
}
