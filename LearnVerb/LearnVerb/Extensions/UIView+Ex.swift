//
//  UIView+Ex.swift
//  LearnVerb
//
//  Created by Ruslan Galiev on 4/22/23.
//

import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach {view in
            addSubview(view)
        }
    }
}
