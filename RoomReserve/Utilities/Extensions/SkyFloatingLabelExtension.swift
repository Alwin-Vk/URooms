//
//  SkyFloatingLabelExtension.swift
//  TipTop
//
//  Copyright © 2020 ArmiaSystems. All rights reserved.
//

import Foundation
import UIKit
import SkyFloatingLabelTextField

enum TextFieldValueType: Int {
    case none
    case onlyLetters
    case onlyNumbers
    case phoneNumber   // Allowed "+0123456789"
    case alphaNumeric
    case fullName       // Allowed letters and space
}

extension SkyFloatingLabelTextField {

    public func styleField(_ textColor: UIColor? = nil) {
        self.font = UIFont.systemFont(ofSize: 16)
        self.tintColor = #colorLiteral(red: 0.2705882353, green: 0.3529411765, blue: 0.3921568627, alpha: 1)

        self.lineHeight = 0
        self.selectedLineHeight = 0
        self.selectedTitleColor = #colorLiteral(red: 0.2705882353, green: 0.3529411765, blue: 0.3921568627, alpha: 1)
        self.titleFormatter = { $0 }
        self.titleFont = UIFont.systemFont(ofSize: 12)

        self.textColor = #colorLiteral(red: 0.1490196078, green: 0.1960784314, blue: 0.2196078431, alpha: 1)
        self.titleColor = #colorLiteral(red: 0.2705882353, green: 0.3529411765, blue: 0.3921568627, alpha: 1)
        self.lineColor = .clear
        self.placeholderColor = #colorLiteral(red: 0.2705882353, green: 0.3529411765, blue: 0.3921568627, alpha: 1)
        self.textErrorColor = #colorLiteral(red: 0.1490196078, green: 0.1960784314, blue: 0.2196078431, alpha: 1)
        self.errorColor = #colorLiteral(red: 0.8980392157, green: 0.2235294118, blue: 0.2078431373, alpha: 1)
    }
    
    public func styleField2(_ textColor: UIColor? = nil) {
        self.font = UIFont.systemFont(ofSize: 16)
        self.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

        self.lineHeight = 0
        self.selectedLineHeight = 0
        self.selectedTitleColor = #colorLiteral(red: 0.453784585, green: 0.6457867622, blue: 0.9323995709, alpha: 1)
        self.titleFormatter = { $0 }
        self.titleFont = UIFont.systemFont(ofSize: 12)

        self.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.titleColor = #colorLiteral(red: 0.453784585, green: 0.6457867622, blue: 0.9323995709, alpha: 1)
        self.lineColor = .clear
        self.placeholderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.textErrorColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.errorColor = #colorLiteral(red: 0.8980392157, green: 0.2235294118, blue: 0.2078431373, alpha: 1)
    }


    public func setError(_ errorText: String = "") {
        self.errorMessage = errorText
    }

    // swiftlint:disable:next cyclomatic_complexity
    func verifyFields(shouldChangeCharactersIn range: NSRange, replacementString string: String, type: TextFieldValueType = .none, maxLength: Int = 50) -> Bool {

        switch type {
        case .none:
            break // Do nothing

        case .onlyLetters:
            let characterSet = CharacterSet.letters
            if string.rangeOfCharacter(from: characterSet.inverted) != nil {
                return false
            }

        case .onlyNumbers:
            let numberSet = CharacterSet.decimalDigits
            if string.rangeOfCharacter(from: numberSet.inverted) != nil {
                return false
            }

        case .phoneNumber:
            let phoneNumberSet = CharacterSet(charactersIn: "+0123456789")
            if string.rangeOfCharacter(from: phoneNumberSet.inverted) != nil {
                return false
            }

        case .alphaNumeric:
            let alphaNumericSet = CharacterSet.alphanumerics
            if string.rangeOfCharacter(from: alphaNumericSet.inverted) != nil {
                return false
            }

        case .fullName:
            var characterSet = CharacterSet.letters
            characterSet = characterSet.union(CharacterSet(charactersIn: " "))
            if string.rangeOfCharacter(from: characterSet.inverted) != nil {
                return false
            }
        }

        if let text = self.text, let textRange = Range(range, in: text) {
            let finalText = text.replacingCharacters(in: textRange, with: string)
            if maxLength > 0, maxLength < finalText.utf8.count {
                return false
            }
        }

        return true
    }

}
