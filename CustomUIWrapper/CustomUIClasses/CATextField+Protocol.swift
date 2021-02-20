//
//  CATextField+Protocol.swift
//  VaidayG
//
//  Created by Avinash Kashyap on 29/10/2019.
//  Copyright © 2019 Avinash Kashyap. All rights reserved.
//

import Foundation

public protocol CATextFieldDelegate: NSObjectProtocol {
    
    func caTextFieldDidBeginEditing(_ caTextField: CATextField)
    func caTextFieldDidEndEditing(_ caTextField: CATextField)
    func caTextField(_ caTextField: CATextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    func caTextFieldShouldReturn(_ caTeextField: CATextField) -> Bool
    func caTextFieldShouldClear(_ caTeextField: CATextField) -> Bool
}

extension CATextFieldDelegate {

    func caTextFieldDidBeginEditing(_ caTextField: CATextField) {
        
    }
    func caTextFieldDidEndEditing(_ caTextField: CATextField) {
        
    }
    func caTextField(_ caTextField: CATextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    func caTextFieldShouldReturn(_ caTeextField: CATextField) -> Bool {
        return true
    }
    func caTextFieldShouldClear(_ caTeextField: CATextField) -> Bool {
        return true
    }
}
