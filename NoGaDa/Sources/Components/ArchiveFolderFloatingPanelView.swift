//
//  ArchiveFloatingPanel.swift
//  NoGaDa
//
//  Created by 이승기 on 2021/10/06.
//

import UIKit

import FloatingPanel


final class ArchiveFolderFloatingPanelView {
  
  // MARK: - Properties
  
  private var floatingPanel = FloatingPanelController()
  private weak var parentViewController: UIViewController?
  private weak var contentViewDelegate: PopUpArchiveFolderViewDelegate?
  
  
  // MARK: - Initializers
  
  init(parentViewController: UIViewController, delegate: PopUpArchiveFolderViewDelegate) {
    self.parentViewController = parentViewController
    self.contentViewDelegate = delegate
    setup()
  }
  
  
  // MARK: - Setups
  
  private func setup() {
    let appearance = SurfaceAppearance()
    appearance.cornerRadius = 28
    
    let shadow = SurfaceAppearance.Shadow()
    shadow.color = UIColor.gray
    shadow.offset = CGSize(width: 0, height: 16)
    shadow.radius = 16
    shadow.spread = 8
    appearance.shadows = [shadow]
    
    floatingPanel.removeFromParent()
    floatingPanel.contentMode = .fitToBounds
    floatingPanel.backdropView.dismissalTapGestureRecognizer.isEnabled = true
    floatingPanel.surfaceView.appearance = appearance
    floatingPanel.surfaceView.grabberHandle.barColor = R.color.accentYellowDark()!
    floatingPanel.layout = ArchiveSongFloatingPanelLayout()
  }
  
  
  // MARK: - Methods
  
  public func show(_ selectedSong: Song) {
    prepareForShow(selectedSong)
    floatingPanel.show(animated: true, completion: nil)
    floatingPanel.move(to: .half, animated: true)
  }
  
  public func hide(animated: Bool) {
    floatingPanel.hide(animated: animated) { [weak self] in
      self?.floatingPanel.removeFromParent()
      self?.floatingPanel.dismiss(animated: false, completion: nil)
    }
  }
  
  private func prepareForShow(_ selectedSong: Song) {
    let storyboard = UIStoryboard(name: R.storyboard.folder.name, bundle: nil)
    let viewController = storyboard.instantiateViewController(identifier: PopUpArchiveFolderViewController.identifier,
                                                              creator: { coder -> PopUpArchiveFolderViewController in
      let viewModel = PopUpArchiveFolderViewModel(selectedSong: selectedSong)
      return .init(coder, viewModel) ?? PopUpArchiveFolderViewController(.init())
    })
    
    viewController.delegate = contentViewDelegate
    viewController.exitButtonAction = { [weak self] in
      self?.hide(animated: true)
    }
    
    floatingPanel.removeFromParent()
    floatingPanel.set(contentViewController: viewController)
    floatingPanel.addPanel(toParent: parentViewController!)
  }
}
