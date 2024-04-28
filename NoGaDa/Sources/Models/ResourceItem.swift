//
//  IconResourceItem.swift
//  NoGaDa
//
//  Created by 이승기 on 2021/09/29.
//

import UIKit


enum ResourceItem: CaseIterable {
  case archiveIllustration
  
  var description: String {
    switch self {
    case .archiveIllustration:
      return "Vecteezy.com"
    }
  }
  
  var image: UIImage {
    switch self {
    case .archiveIllustration:
      return UIImage(named: "ArchiveShortcutBackgroundImage")!
    }
  }
  
  var link: String {
    switch self {
    case .archiveIllustration:
      return "https://www.vecteezy.com/vector-art/217562-women-of-color-singer"
    }
  }
  
  func openLink(vc: UIViewController) {
    switch self {
    case .archiveIllustration:
      if let url = URL(string: self.link) {
        UIApplication.shared.open(url, options: [:])
      }
    }
  }
}
