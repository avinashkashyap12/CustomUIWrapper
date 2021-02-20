//
//  UICusomisation.swift
//  VaidayG
//
//  Created by Avinash Kashyap on 29/10/2019.
//  Copyright © 2019 Avinash Kashyap. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    func addBorder(_ width: CGFloat, borderColor color: UIColor) {
        guard width > 0 else {
            return
        }
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }

    func addCornerRadius(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }

    func addBoarder(_ width: CGFloat, borderColor color: UIColor,
                    andCornerRadius radius: CGFloat) {
        self.addBorder(width, borderColor: color)
        self.addCornerRadius(radius)
    }
}


class UICustomisationConstant {
    static let defaultStrokeWidth: CGFloat = 2.0
}
