//
//  BugReportAction.swift
//  NoGaDa
//
//  Created by 이승기 on 2023/09/28.
//

import UIKit

import MessageUI


class BugReportAction: SettingAction {
  var title: String {
    return "버그 리포트"
  }
  
  var icon: UIImage {
    return R.image.chat()!
  }
  
  var iconContainerColor: UIColor {
    return R.color.iconBasic()!
  }
  
  func performAction(on vc: UIViewController) {
    if MFMailComposeViewController.canSendMail() {
      let composeVC = MFMailComposeViewController()
      composeVC.setToRecipients(["avocado.34.131@gmail.com"])
      composeVC.setSubject("노가다앱 버그 및 피드백 리포트")
      composeVC.setMessageBody("", isHTML: false)
      vc.present(composeVC, animated: true, completion: nil)
    } else {
      print("can't send an email because some reason")
    }
  }
}
