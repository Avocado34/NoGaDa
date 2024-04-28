//
//  SettingViewController.swift
//  NoGaDa
//
//  Created by 이승기 on 2021/09/29.
//

import UIKit

import RxSwift
import RxCocoa


final class SettingViewController: BaseViewController {
  
  // MARK: - Constants
  
  static let identifier = R.storyboard.setting.settingStoryboard.identifier
  
  struct Metric {
    static let settingItemTableViewCornerRadius = 16.f
    static let settingItemTableViewTopInset = 12.f
    static let settingItemTableViewBottomInset = 12.f
  }
  
  
  // MARK: Types
  
  typealias ViewModel = SettingViewModel
  
  
  // MARK: - Properties
  
  private var viewModel: ViewModel
  
  
  // MARK: - UI
  
  @IBOutlet weak var exitButton: UIButton!
  @IBOutlet weak var settingItemTableView: UITableView!
  
  
  // MARK: - Lifecycle
  
  required init(_ viewModel: ViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    dismiss(animated: true)
  }
  
  required init?(_ coder: NSCoder, _ viewModel: ViewModel) {
    self.viewModel = viewModel
    super.init(coder: coder)
  }
  
  required init?(coder: NSCoder) {
    fatalError("ViewModel has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    bind()
  }
  
  
  // MARK: - Setups
  
  private func setup() {
    setupView()
  }
  
  private func setupView() {
    setupSettingItemTableView()
  }
  
  
  // MARK: - Binding
  
  private func bind() {
    bindInputs()
    bindOutputs()
  }
  
  private func bindInputs() {
    exitButton.rx.tap
      .bind(to: viewModel.input.tapExitButton)
      .disposed(by: disposeBag)
  }
  
  private func bindOutputs() {
    viewModel.output.dismiss
      .asDriver(onErrorDriveWith: .never())
      .drive(with: self, onNext: { vc, _ in
        vc.dismiss(animated: true)
      })
      .disposed(by: disposeBag)
    
    viewModel.output.settingItems
      .bind(to: settingItemTableView.rx.items(cellIdentifier: SettingItemTableViewCell.identifier, cellType: SettingItemTableViewCell.self)) { index, item, cell in
        cell.configure(action: item.action)
        cell.itemSelectAction = { [weak self] in
          guard let vc = self else { return }
          item.action.performAction(on: vc)
        }
      }
      .disposed(by: disposeBag)
  }
  
  private func setupSettingItemTableView() {
    registerEtcTableCell()
    settingItemTableView.layer.cornerRadius = Metric.settingItemTableViewCornerRadius
    settingItemTableView.tableFooterView = UIView()
    settingItemTableView.isScrollEnabled = false
    settingItemTableView.separatorStyle = .none
    settingItemTableView.contentInset = .init(top: Metric.settingItemTableViewTopInset, left: 0, bottom: Metric.settingItemTableViewBottomInset, right: 0)
  }
  
  private func registerEtcTableCell() {
    let nibName = UINib(nibName: R.nib.settingItemTableViewCell.name, bundle: nil)
    settingItemTableView.register(nibName, forCellReuseIdentifier: SettingItemTableViewCell.identifier)
  }
}
