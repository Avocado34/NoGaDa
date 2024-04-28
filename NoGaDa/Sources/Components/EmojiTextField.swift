//
//  EmojiTextField.swift
//  NoGaDa
//
//  Created by 이승기 on 2021/09/19.
//

import UIKit


class EmojiTextField: UITextField {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setup()
  }
  
  // required for iOS 13
  override var textInputContextIdentifier: String? { "" }
  
  override var textInputMode: UITextInputMode? {
    for mode in UITextInputMode.activeInputModes {
      if mode.primaryLanguage == "emoji" {
        return mode
      }
    }
    return nil
  }
  
  override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
    if action == #selector(UIResponderStandardEditActions.paste(_:)) {
      return false
    }
    return super.canPerformAction(action, withSender: sender)
  }
  
  private func setup() {
    delegate = self
    tintColor = .clear
    setRandomEmoji()
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if string.isSingleEmoji {
      textField.text = ""
      return true
    } else {
      return false
    }
  }
  
  func setRandomEmoji() {
    text = String(UnicodeScalar(Array(0x1F300...0x1F3F0).randomElement()!)!)
  }
}

extension EmojiTextField: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    endEditing(true)
  }
}

extension Character {
  /// A simple emoji is one scalar and presented to the user as an Emoji
  var isSimpleEmoji: Bool {
    guard let firstScalar = unicodeScalars.first else { return false }
    return firstScalar.properties.isEmoji && firstScalar.value > 0x238C
  }
  
  /// Checks if the scalars will be merged into an emoji
  var isCombinedIntoEmoji: Bool { unicodeScalars.count > 1 && unicodeScalars.first?.properties.isEmoji ?? false }
  
  var isEmoji: Bool { isSimpleEmoji || isCombinedIntoEmoji }
}

extension String {
  var isSingleEmoji: Bool { count == 1 && containsEmoji }
  
  var containsEmoji: Bool { contains { $0.isEmoji } }
  
  var containsOnlyEmoji: Bool { !isEmpty && !contains { !$0.isEmoji } }
  
  var emojiString: String { emojis.map { String($0) }.reduce("", +) }
  
  var emojis: [Character] { filter { $0.isEmoji } }
  
  var emojiScalars: [UnicodeScalar] { filter { $0.isEmoji }.flatMap { $0.unicodeScalars } }
}
