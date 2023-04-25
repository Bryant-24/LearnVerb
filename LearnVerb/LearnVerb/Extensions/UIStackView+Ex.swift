//
//  UIStackView+Ex.swift
//  LearnVerb
//
//  Created by Ruslan Galiev on 4/22/23.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach {view in
            addArrangedSubview(view)
        }
    }
}
