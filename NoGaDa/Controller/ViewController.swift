//
//  ViewController.swift
//  NoGaDa
//
//  Created by 이승기 on 2021/09/17.
//

import UIKit

import RxCocoa
import RxSwift
import RxGesture
import FloatingPanel

class ViewController: UIViewController {

    // MARK: Declaration
    var disposeBag = DisposeBag()
    let archiveFloatingPanel = FloatingPanelController()
    
    @IBOutlet weak var archiveShortcutView: UIView!
    @IBOutlet weak var searchBoxView: UIView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var chartTableView: UITableView!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        initInstance()
        initEventListener()
    }
    
    // MARK: - Override
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }

    // MARK: - Initialization
    private func initView() {
        self.hero.isEnabled = true
        
        // Search TextField
        searchBoxView.hero.id = "searchBar"
        searchBoxView.layer.cornerRadius = 12
        
        // Search Button
        searchButton.hero.id = "searchButton"
        searchButton.layer.cornerRadius = 8
        
        // Archive Shortcut View (Button)
        archiveShortcutView.layer.cornerRadius = 20
        
        // Chart TableView
        chartTableView.layer.cornerRadius = 12
        chartTableView.tableFooterView = UIView()
        chartTableView.separatorStyle = .none
    }
    
    private func initInstance() {
        // Chart TableView
        let chartTableCellNibName = UINib(nibName: "ChartTableViewCell", bundle: nil)
        chartTableView.register(chartTableCellNibName, forCellReuseIdentifier: "chartTableViewCell")
        chartTableView.delegate = self
        chartTableView.dataSource = self
    }
    
    private func initEventListener() {
        // Search Textfield Tap Action
        searchBoxView.rx.tapGesture()
            .when(.recognized)
            .bind(with: self) { vc, _ in
                vc.presentSearchVC()
                vc.archiveFloatingPanel.hide(animated: true)
            }.disposed(by: disposeBag)
        
        // Search Textfield LongPress Action
        searchBoxView.rx.longPressGesture()
            .when(.began)
            .bind(with: self) { vc, _ in
                vc.presentSearchVC()
                vc.archiveFloatingPanel.hide(animated: true)
            }.disposed(by: disposeBag)
        
        // Search Button Tap Action
        searchButton.rx.tapGesture()
            .when(.recognized)
            .bind(with: self) { vc, _ in
                vc.presentSearchVC()
                vc.archiveFloatingPanel.hide(animated: true)
            }.disposed(by: disposeBag)
        
        // Archive Shortcut Tap Action
        archiveShortcutView.rx.tapGesture()
            .when(.recognized)
            .bind(with: self) { vc, _ in
                vc.presentArchiveVC()
                vc.archiveFloatingPanel.hide(animated: true)
            }.disposed(by: disposeBag)
    }
    
    // MARK: - Method
    func presentSearchVC() {
        guard let searchVC = storyboard?.instantiateViewController(identifier: "searchStoryboard") as? SearchViewController else { return }
        searchVC.modalPresentationStyle = .fullScreen
        
        present(searchVC, animated: true, completion: nil)
    }
    
    func presentArchiveVC() {
        guard let archiveVC = storyboard?.instantiateViewController(identifier: "archiveStoryboard") as? ArchiveViewController else { return }
        archiveVC.modalPresentationStyle = .fullScreen
        
        present(archiveVC, animated: true, completion: nil)
    }
    
    private func configurePopUpArchivePanel() {
        let appearance = SurfaceAppearance()
        appearance.cornerRadius = 32
        appearance.setPanelShadow(color: ColorSet.floatingPanelShadowColor)
        
        archiveFloatingPanel.removeFromParent()
        archiveFloatingPanel.isRemovalInteractionEnabled = true
        archiveFloatingPanel.contentMode = .fitToBounds
        archiveFloatingPanel.surfaceView.appearance = appearance
        archiveFloatingPanel.surfaceView.grabberHandle.barColor = ColorSet.accentSubColor
        archiveFloatingPanel.layout = PopUpArchiveFloatingPanelLayout()
        
        guard let popUpArchiveVC = storyboard?.instantiateViewController(identifier: "popUpArchiveStoryboard") as? PopUpArchiveViewController else { return }
        popUpArchiveVC.exitButtonAction = { [weak self] in
            self?.archiveFloatingPanel.hide(animated: true)
        }
        archiveFloatingPanel.set(contentViewController: popUpArchiveVC)
        archiveFloatingPanel.addPanel(toParent: self)
    }
    
    private func showPopUpArchivePanel() {
        configurePopUpArchivePanel()
        archiveFloatingPanel.show(animated: true, completion: nil)
        archiveFloatingPanel.move(to: .half, animated: true)
    }
}

// MARK: - Extension
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let chartCell = tableView.dequeueReusableCell(withIdentifier: "chartTableViewCell") as? ChartTableViewCell else { return UITableViewCell() }
        
        chartCell.chartNumberLabel.text = "\(indexPath.row + 1)"
        
        return chartCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showPopUpArchivePanel()
    }
}