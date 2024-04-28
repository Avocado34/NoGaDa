//
//  SongOption.swift
//  NoGaDa
//
//  Created by 이승기 on 2021/12/14.
//

import UIKit


protocol SongOption {
  var title: String { get }
  var icon: UIImage { get }
}

struct MoveToOtherFolder: SongOption {
  var title: String = "다른 폴더로 이동"
  var icon: UIImage = UIImage(named: "folder")!
}

struct RemoveFromFolder: SongOption {
  var title: String = "삭제"
  var icon: UIImage = UIImage(named: "trash-bin")!
}
