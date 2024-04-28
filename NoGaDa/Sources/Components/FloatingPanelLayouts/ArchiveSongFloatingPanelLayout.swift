//
//  PopUpArchiveFloatingPanelLayout.swift
//  NoGaDa
//
//  Created by 이승기 on 2021/09/17.
//

import FloatingPanel


final class ArchiveSongFloatingPanelLayout: FloatingPanelLayout {
  let position: FloatingPanelPosition = .bottom
  let initialState: FloatingPanelState = .tip
  var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
    return [
      .full: FloatingPanelLayoutAnchor(absoluteInset: 16.0, edge: .top, referenceGuide: .safeArea),
      .half: FloatingPanelLayoutAnchor(fractionalInset: 0.5, edge: .bottom, referenceGuide: .safeArea),
      .tip: FloatingPanelLayoutAnchor(absoluteInset: 220, edge: .bottom, referenceGuide: .safeArea),
    ]
  }
  
  func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
    switch state {
    case .full, .half: return 0.5
    default: return 0.0
    }
  }
}
