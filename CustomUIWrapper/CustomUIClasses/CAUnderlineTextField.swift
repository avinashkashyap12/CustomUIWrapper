//
//  CAUnderlineTextField.swift
//  VaidayG
//
//  Created by Avinash Kashyap on 29/10/2019.
//  Copyright © 2019 Avinash Kashyap. All rights reserved.
//

import Foundation
import UIKit

class CAUnderLineTextField: UITextField {

    internal var underLineColor: UIColor = UIColor.lightGray {
        didSet {
            self.setNeedsDisplay()
        }
    }

    internal var underLineWidth: CGFloat = UICustomisationConstant.defaultStrokeWidth {
        didSet {
            self.setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let path = UIBezierPath.init()
        path.move(to: CGPoint.init(x: 0, y: self.frame.size.height))
        path.addLine(to: CGPoint.init(x: self.frame.size.width, y: self.frame.size.height))
        self.underLineColor.setStroke()
        path.lineWidth = self.underLineWidth
        path.stroke()
    }
}

class CAUnderlineLabel: UILabel {

    internal var underLineColor: UIColor = UIColor.lightGray {
        didSet {
            self.setNeedsDisplay()
        }
    }

    internal var underLineWidth: CGFloat = UICustomisationConstant.defaultStrokeWidth {
        didSet {
            self.setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        super.drawText(in: rect)
        let path = UIBezierPath.init()
        path.move(to: CGPoint.init(x: 0, y: self.frame.size.height))
        path.addLine(to: CGPoint.init(x: self.frame.size.width, y: self.frame.size.height))
        self.underLineColor.setStroke()
        path.lineWidth = self.underLineWidth
        path.stroke()
    }
}
