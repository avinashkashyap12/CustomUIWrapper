//
//  CATextField.swift
//  VaidayG
//
//  Created by Avinash Kashyap on 29/10/2019.
//  Copyright © 2019 Avinash Kashyap. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
open class CATextField: UIView {

    @IBInspectable open var placeHolder: String? {
        didSet {
            self.placeHolderLabel.text = self.placeHolder
        }
    }

    @IBInspectable open var placeHolderTextColor: UIColor = UIColor.lightGray {
        didSet {
            self.placeHolderLabel.textColor = self.placeHolderTextColor
        }
    }

    @IBInspectable open var textColor: UIColor? = UIColor.black {
        didSet {
            self.textFiled.textColor = self.textColor
        }
    }

    @IBInspectable open var text: String {
        set {
            self.textFiled.text = newValue
            self.updatePlaceholderLabel()
        }
        get {
            return self.textFiled.text ?? ""
        }
    }

    @IBInspectable open var borderStrokeWidth: CGFloat = UICustomisationConstant.defaultStrokeWidth {
        didSet {
            self.textFiled.underLineWidth = self.borderStrokeWidth
        }
    }

    private func updatePlaceholderLabel() {
        let transform = self.animationTransform()
        //self.placeHolderLabel.transform = transform
        UIView.animate(withDuration: 0.3) {
            self.bottomConstraint.constant = self.animatedBottomConstant
            self.placeHolderLabel.transform = transform
        }
    }
    
    @IBInspectable open var font: UIFont? {
        didSet {
            self.textFiled.font = self.font
        }
    }

    @IBInspectable open var underLineColor: UIColor = UIColor.lightGray {
        didSet {
            self.textFiled.underLineColor = self.underLineColor
        }
    }

    // Presented when object becomes first responder.  If set to nil, reverts to following responder chain.  If
    // set while first responder, will not take effect until reloadInputViews is called.
    open var caInputView: UIView? {
        get {
            return self.textFiled.inputView
        }
        set {
            self.textFiled.inputView = newValue
        }
    }

    open var caInputAccessoryView: UIView? {
        get {
            return self.textFiled.inputAccessoryView
        }
        set {
            self.textFiled.inputAccessoryView = newValue
        }
    }

    fileprivate var placeHolderLabel = UILabel()
    fileprivate var textFiled = CAUnderLineTextField()
    fileprivate var bottomConstraint: NSLayoutConstraint!
    
    let defaultBottomConstant: CGFloat = -2.0
    let animatedBottomConstant: CGFloat = -22.0

    weak open var delegate: CATextFieldDelegate?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpCATextField()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setUpCATextField()
    }
}

extension CATextField {

    fileprivate func setUpCATextField() {

        self.textFiled.contentVerticalAlignment = .bottom
        self.textFiled.borderStyle = .none
        self.textFiled.underLineColor = self.underLineColor
        self.addSubview(textFiled)
        self.textFiled.delegate = self
        self.textFiled.translatesAutoresizingMaskIntoConstraints = false
        self.textFiled.textColor = self.textColor

        let leadingConstraint = NSLayoutConstraint.init(item: self.textFiled as Any, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 20)
        let trailingConstraint = NSLayoutConstraint.init(item: self.textFiled as Any, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: -20)
        let bottomConstraint = NSLayoutConstraint.init(item: self.textFiled as Any, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: -2)
        let heightConstraint = NSLayoutConstraint.init(item: self.textFiled as Any, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.height, multiplier: 0.8, constant: 1)
        self.addConstraints([leadingConstraint, trailingConstraint, bottomConstraint, heightConstraint])

        /// add place holder label
        self.setupPlaceHolderLabel()
    }

    fileprivate func setupPlaceHolderLabel() {
        self.placeHolderLabel.backgroundColor = UIColor.clear
        self.placeHolderLabel.translatesAutoresizingMaskIntoConstraints = false
        self.placeHolderLabel.text = self.placeHolder
        self.placeHolderLabel.textColor = self.placeHolderTextColor
        self.placeHolderLabel.isUserInteractionEnabled = false
        self.insertSubview(self.placeHolderLabel, belowSubview: self.textFiled)

        let leadingConstraint = NSLayoutConstraint.init(item: self.placeHolderLabel as Any, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.textFiled, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)
        self.bottomConstraint = NSLayoutConstraint.init(item: self.placeHolderLabel as Any, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.textFiled, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: defaultBottomConstant)
        let widthConstraint = NSLayoutConstraint.init(item: self.placeHolderLabel as Any, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.lessThanOrEqual, toItem: self.textFiled, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: 1)
        
        let heightConstraint = NSLayoutConstraint.init(item: self.placeHolderLabel as Any, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.textFiled, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant: -21)

        self.addConstraints([leadingConstraint, widthConstraint, self.bottomConstraint, heightConstraint])
    }
}

extension CATextField: UITextFieldDelegate {

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        self.didBeginEditing()
        self.delegate?.caTextFieldDidBeginEditing(self)
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.didEndEditing()
        self.delegate?.caTextFieldDidEndEditing(self)
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        var enteredText = self.textFiled.text
//        if range.length == 1 {
//            enteredText?.removeLast()
//        } else {
//            enteredText?.append(string)
//        }
//        self.textFiled.text = enteredText
        return self.delegate?.caTextField(self, shouldChangeCharactersIn: range, replacementString: string) ?? true
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return self.delegate?.caTextFieldShouldReturn(self) ?? true
    }

    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return self.delegate?.caTextFieldShouldClear(self) ?? true
    }
}

extension CATextField {

    fileprivate func didBeginEditing() {
        if self.bottomConstraint.constant == defaultBottomConstant {
            // animate placeholder label
            self.animatePlaceHolderLabel(to: animatedBottomConstant)
        }
    }

    private func animationTransform() -> CGAffineTransform {
        return CGAffineTransform.init(scaleX: 0.85, y: 0.85)
    }

    private func defaultTransform() -> CGAffineTransform {
        return CGAffineTransform.init(scaleX: 1.0, y: 1.0)
    }

    private func transform(_ constant: CGFloat) -> CGAffineTransform {
        if constant == defaultBottomConstant {
            return self.defaultTransform()
        }
        return self.animationTransform()
    }

    fileprivate func didChangeText() {
        
    }

    fileprivate func didEndEditing() {
        if let text = self.textFiled.text, text.isEmpty {
            // animate placeholder label to back
            self.animatePlaceHolderLabel(to: defaultBottomConstant)
        }
    }

    fileprivate func animatePlaceHolderLabel(to constant: CGFloat) {
        self.bottomConstraint.constant = constant
        self.performTranformation(to: constant)
    }

    fileprivate func performTranformation(to constant: CGFloat) {
        let transform = self.transform(constant)
        UIView.animate(withDuration: 0.3) {
            self.placeHolderLabel.transform = transform
            self.layoutIfNeeded()
        }
    }
}
