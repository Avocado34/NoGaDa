//
//  ArchiveFloatingPanel.swift
//  NoGaDa
//
//  Created by 이승기 on 2021/10/06.
//

import UIKit
import FloatingPanel

class ArchiveFolderFloatingPanelView {
    
    private var floatingPanel = FloatingPanelController()
    private var parentViewController: UIViewController?
    private var contentViewDelegate: PopUpArchiveFolderViewDelegate?
    
    init(parentViewController: UIViewController, delegate: PopUpArchiveFolderViewDelegate) {
        self.parentViewController = parentViewController
        self.contentViewDelegate = delegate
        setup()
    }
    
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
        floatingPanel.surfaceView.grabberHandle.barColor = ColorSet.floatingPanelHandleColor
        floatingPanel.layout = ArchiveSongFloatingPanelLayout()
    }
    
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
        let storyboard = UIStoryboard(name: "Folder", bundle: nil)
        let archiveFolderListVC = storyboard.instantiateViewController(identifier: "popUpArchiveStoryboard") { coder -> PopUpArchiveFolderListViewController in
            let viewModel = PopUpArchiveFolderListViewModel(selectedSong: selectedSong)
            return .init(coder, viewModel) ?? PopUpArchiveFolderListViewController(.init())
        }
        
        archiveFolderListVC.delegate = contentViewDelegate
        archiveFolderListVC.exitButtonAction = { [weak self] in
            self?.hide(animated: true)
        }
        
        floatingPanel.removeFromParent()
        floatingPanel.set(contentViewController: archiveFolderListVC)
        floatingPanel.addPanel(toParent: parentViewController!)
    }
}