//
//  CAPasscodeField.swift
//  VaidayG
//
//  Created by Avinash Kashyap on 29/10/2019.
//  Copyright © 2019 Avinash Kashyap. All rights reserved.
//

import Foundation
import UIKit

protocol CAPasscodeFieldDelegate: NSObjectProtocol {
    func passcodeField(_ passcodeView: CAPasscodeField, didChangeText text: String)
}

@objc public enum PasscodeeBorderStyle: Int {

    case underLine = 0
    case roundedRectangle
    case rectangle
}

@IBDesignable
open class CAPasscodeField: UIView, UITextInputTraits {

    @IBInspectable open var numberOfFields: Int = 4 {
        didSet {
            self.addPasscodeLabels()
        }
    }

    @IBInspectable open var borderColor: UIColor = UIColor.lightGray {
        didSet {
            self.updateUnderLineColor()
        }
    }

    fileprivate var caBorderStyle: PasscodeeBorderStyle = .underLine {
        didSet {
            self.updatePasscodeLabelBorderStyle(self.caBorderStyle)
        }
    }

    @IBInspectable open var boxPadding: CGFloat = 10.0 {
        didSet {
            self.addPasscodeLabels()
        }
    }
    @IBInspectable open var borderStrokeWidth: CGFloat = UICustomisationConstant.defaultStrokeWidth {
        didSet {
            self.updatePasscodeLabelBorderStyle(self.caBorderStyle)
        }
    }

    @IBInspectable open var borderStyle: Int {
        set {
            var value = newValue
            if newValue > 2 {
                value = 2
            } else if newValue < 0 {
                value = 0
            }
            self.caBorderStyle = PasscodeeBorderStyle.init(rawValue: value) ?? .underLine
        }
        get {
            self.caBorderStyle.rawValue
        }
    }

    fileprivate let animationName = "OpacityAnimation"
    fileprivate let passcodeTagValue = 100
    fileprivate var textField = UITextField()
    fileprivate var passcode: String = ""
    fileprivate var passcodeLabelWidth: CGFloat = 0
    fileprivate var passcodeLabelHeight: CGFloat = 0
    weak var delegate: CAPasscodeFieldDelegate?
    fileprivate var passcodes: [String] = []

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpCATextField()
    }

    @IBInspectable open var keyboardType: UIKeyboardType = .default {
        didSet {
            self.textField.keyboardType = self.keyboardType
        }
    }

    override public var tintColor: UIColor! {
        didSet {
            self.cursorView.backgroundColor = self.tintColor
        }
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setUpCATextField()
    }
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.setUpCATextField()
    }

    private lazy var cursorView: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 2, height: 20))
        view.center = CGPoint.init(x: passcodeLabelWidth/2, y: passcodeLabelHeight/2)
        view.backgroundColor = self.tintColor
        return view
    }()
}

extension CAPasscodeField {

    fileprivate func setUpCATextField() {

        self.textField.frame = self.bounds
        self.textField.textColor = UIColor.clear
        self.textField.tintColor = UIColor.clear
        self.textField.backgroundColor = UIColor.clear
        self.textField.alpha = 1
        self.textField.delegate = self
        self.textField.autocorrectionType = .no
        self.textField.spellCheckingType = .no
        self.textField.autocapitalizationType = .none
        self.insertSubview(self.textField, at: 0)
        self.textField.keyboardType = UIKeyboardType.alphabet
        self.addPasscodeLabels()
    }

    fileprivate func updateUnderLineColor() {
        for i in 0 ..< numberOfFields {
            let label = self.passcodeLabel(for: i)
            if self.caBorderStyle == .underLine {
                label.underLineColor = self.borderColor
            } else {
                label.layer.borderColor = self.borderColor.cgColor
            }
        }
    }

    fileprivate func addPasscodeLabels() {

        passcodeLabelWidth = (self.frame.size.width / CGFloat(numberOfFields)) - (self.boxPadding / 2)
        passcodeLabelHeight = self.frame.size.height - 10

        for i in 0 ..< numberOfFields {
            let label = self.passcodeLabel(for: i)
            label.frame = CGRect.init(x: 0.0, y: 0.0,
                                      width: passcodeLabelWidth,
                                      height: passcodeLabelHeight)
            label.center = self.centerPoint(for: i)
        }
    }

    private func centerPoint(for index: Int) -> CGPoint {
        let width = self.frame.size.width / CGFloat(numberOfFields)
        let x = (width * CGFloat(index)) + (width/2)
        return CGPoint.init(x: x, y: self.frame.size.height/2)
    }

    fileprivate func passcodeLabel(for tag: Int) -> CAUnderlineLabel {
        let tagValue = self.passcodeLabelTag(tag)
        if let label = self.viewWithTag(tagValue) as? CAUnderlineLabel {
            return label
        }

        let label = CAUnderlineLabel()
        label.underLineColor = self.borderColor
        label.backgroundColor = UIColor.clear
        label.tag = tagValue
        label.textColor = UIColor.black
        label.textAlignment = .center
        //label.addBoarder(1, borderColor: UIColor.lightGray, andCornerRadius: 5)
        self.addSubview(label)
        return label
    }

    private func passcodeLabelTag(_ tag: Int) -> Int {
        return passcodeTagValue + tag
    }

    fileprivate func updatePasscodeLabelBorderStyle(_ style: PasscodeeBorderStyle = .underLine) {
        for i in 0 ..< numberOfFields {
            let label = self.passcodeLabel(for: i)
            self.passcodeLabel(label, updateBorderStyle: style)
        }
        
    }

    fileprivate func passcodeLabel(_ label: CAUnderlineLabel,
                                   updateBorderStyle style: PasscodeeBorderStyle) {
        switch style {
        case .roundedRectangle:
            self.passcodeLabelUpdateRoundedRectBorderStyle(label)
        case .rectangle:
            self.passcodeLabelUpdateLineBorderStyle(label)
        case .underLine:
            self.passcodeLabelUpdateUnderlineBorderStyle(label)
        }
    }

    fileprivate func passcodeLabelUpdateUnderlineBorderStyle(_ label: CAUnderlineLabel) {
        label.underLineWidth = self.borderStrokeWidth
    }

    fileprivate func passcodeLabelUpdateRoundedRectBorderStyle(_ label: CAUnderlineLabel) {
        label.underLineWidth = 0
        label.addBoarder(self.borderStrokeWidth, borderColor: self.borderColor, andCornerRadius: 5)
    }

    fileprivate func passcodeLabelUpdateLineBorderStyle(_ label: CAUnderlineLabel) {
        label.underLineWidth = 0
        label.addBorder(self.borderStrokeWidth, borderColor: self.borderColor)
    }
}

extension CAPasscodeField: UITextFieldDelegate {

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        if let text = self.textField.text, !text.isEmpty {
            self.addTextCursor(at: text.count)
        } else {
            self.addTextCursor(at: 0)
        }
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if string.count > 1 {
            return false
        }
        return self.updateText(in: range, replacementString: string)
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.removeTextCursor()
    }
    
}
extension CAPasscodeField {

    func addTextCursor(at location: Int) {
        guard location < numberOfFields else {
            return
        }
        let label = self.passcodeLabel(for: location)
        label.addSubview(self.cursorView)
        self.addCursorAnimation()
    }

    func removeTextCursor() {
        self.cursorView.removeFromSuperview()
        self.removeCursorAnimation()
    }

    func updateText(in range: NSRange, replacementString string: String) -> Bool {

        guard range.location < numberOfFields else {
            return false
        }
        let label = self.passcodeLabel(for: range.location)
        label.text = string
        /// Add text cursor to current edit label
        if range.length == 0 {
            self.addTextCursor(at: range.location + 1)
            self.passcodes.append(string)
        } else {
            self.addTextCursor(at: range.location)
            self.passcodes.removeLast()
        }
        /// Display and hide text cursor
        if range.location == numberOfFields-1, range.length == 0 {
            self.cursorView.isHidden = true
        } else {
            self.cursorView.isHidden = false
        }
        let text = self.passcodes.joined()
        self.delegate?.passcodeField(self, didChangeText: text)
        print("text : \(text)")
        return true
    }

    fileprivate func addCursorAnimation() {
        let keyPath = "opacity"
        if let animations = self.cursorView.layer.animationKeys(),
            animations.contains(keyPath) {
            return
        }
        let animation = CABasicAnimation.init(keyPath: keyPath)
        animation.fromValue = 1.0
        animation.toValue = [0.0, 0.000001]
        animation.repeatCount = MAXFLOAT
        animation.duration = 0.9
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        self.cursorView.layer.add(animation, forKey: animationName)
    }

    fileprivate func removeCursorAnimation() {
        self.cursorView.layer.removeAnimation(forKey: animationName)
    }
}
