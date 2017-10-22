//
//  MemeTextFieldDelegate.swift
//  MemeMe
//
//  Created by Shirley on 10/8/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import Foundation
import UIKit

// MARK: MemeTextFieldDelegate

class MemeTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    // MARK: textField
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string)
        textField.text = newText
        
        return false
    }
    
    // MARK: textFieldDidBeginEditing
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let defaultText = textField.text! as NSString
        let defautlTextString = String(defaultText)

        if (defautlTextString == "TOP" || defautlTextString == "BOTTOM") {
            textField.text = ""
        }
    }

    // MARK: textFieldShouldReturn
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
