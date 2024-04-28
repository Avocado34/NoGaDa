//
//  SurfaceAppearance+PanelShadow.swift
//  NoGaDa
//
//  Created by 이승기 on 2022/05/08.
//

import FloatingPanel


extension SurfaceAppearance {
  func setPanelShadow(color: UIColor) {
    let shadow = SurfaceAppearance.Shadow()
    shadow.color = color
    shadow.offset = CGSize(width: 0, height: 16)
    shadow.radius = 16
    shadow.spread = 8
    self.shadows = [shadow]
  }
}
