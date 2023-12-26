//
//  Extensions.swift
//  RickAndMorty
//
//  Created by Ricky Silitonga on 16/12/23.
//

import Foundation
import UIKit


extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { view in
            addSubview(view)
        }
    }
}
