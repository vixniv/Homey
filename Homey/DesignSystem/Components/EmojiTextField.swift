//
//  EmojiTextField.swift
//  Homey
//
//  Created by Antigravity on 06/10/26.
//

import SwiftUI
import UIKit

class UIEmojiTextField: UITextField {
    override var textInputMode: UITextInputMode? {
        for mode in UITextInputMode.activeInputModes {
            if mode.primaryLanguage == "emoji" {
                return mode
            }
        }
        return nil
    }
}

struct EmojiTextField: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String = ""
    var fontSize: CGFloat = 24
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: EmojiTextField
        
        init(_ parent: EmojiTextField) {
            self.parent = parent
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            // If the backspace was pressed, we clear the text
            if string.isEmpty {
                textField.text = ""
                parent.text = ""
                return false
            }
            
            // Allow only emoji inputs
            let containsEmoji = string.unicodeScalars.first?.properties.isEmoji ?? false
            if containsEmoji {
                // Keep only the newly selected single emoji
                textField.text = string
                parent.text = string
            }
            return false
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
    }
    
    func makeUIView(context: Context) -> UIEmojiTextField {
        let textField = UIEmojiTextField()
        textField.placeholder = placeholder
        textField.delegate = context.coordinator
        textField.textAlignment = .center
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        
        textField.font = .systemFont(ofSize: fontSize)
        
        // Ensure constraints behavior is flexible
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        return textField
    }
    
    func updateUIView(_ uiView: UIEmojiTextField, context: Context) {
        uiView.text = text
        uiView.font = .systemFont(ofSize: fontSize)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
