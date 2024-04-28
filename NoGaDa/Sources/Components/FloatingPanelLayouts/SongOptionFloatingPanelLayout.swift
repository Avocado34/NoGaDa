//
//  SongOptionFloatingPanelLayout.swift
//  NoGaDa
//
//  Created by 이승기 on 2021/12/14.
//

import FloatingPanel


final class SongOptionFloatingPanelLayout: FloatingPanelLayout {
  let position: FloatingPanelPosition = .bottom
  let initialState: FloatingPanelState = .tip
  var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
    return [
      .half: FloatingPanelLayoutAnchor(absoluteInset: 216, edge: .bottom, referenceGuide: .safeArea),
      .tip: FloatingPanelLayoutAnchor(absoluteInset: 172, edge: .bottom, referenceGuide: .safeArea)
    ]
  }
  
  func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
    switch state {
    case .full, .half: return 0.5
    default: return 0.0
    }
  }
}
