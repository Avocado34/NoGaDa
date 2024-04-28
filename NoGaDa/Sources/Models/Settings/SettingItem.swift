//
//  SettingItem.swift
//  NoGaDa
//
//  Created by 이승기 on 2023/09/28.
//

import Foundation


enum SettingItem: CaseIterable {
  case credit
  case bugReport
  
  var action: SettingAction {
    switch self {
    case .credit:
      return CreditAction()
    case .bugReport:
      return BugReportAction()
    }
  }
}
