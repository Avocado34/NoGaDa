//
//  ImpactFeedbackManager.swift
//  NoGaDa
//
//  Created by 이승기 on 2022/03/06.
//

import UIKit


final class HapticFeedbackManager { }

// MARK: - Notification Feedback
extension HapticFeedbackManager {
  static func playNotificationFeedback(_ type: UINotificationFeedbackGenerator.FeedbackType) {
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(type)
  }
}

// MARK: - Impact Feedback
extension HapticFeedbackManager {
  static func playImpactFeedback(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
    let generator = UIImpactFeedbackGenerator(style: style)
    generator.impactOccurred()
  }
}

// MARK: - Selection Feedback
extension HapticFeedbackManager {
  static func playSelectionFeedback() {
    let generator = UISelectionFeedbackGenerator()
    generator.selectionChanged()
  }
}
