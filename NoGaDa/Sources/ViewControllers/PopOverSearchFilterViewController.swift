//
//  PopOverSearchFilterViewController.swift
//  NoGaDa
//
//  Created by 이승기 on 2021/09/21.
//

import UIKit

import RxSwift
import RxCocoa


final class PopOverSearchFilterViewController: BaseViewController, ViewModelInjectable {
  
  // MARK: - Constants
  
  static let identifier = R.storyboard.search.popOverSearchFilterStoryboard.identifier
  
  struct Metric {
    static let searchFilterTableViewSeparatorLeftInset = 12.f
    static let searchFilterTableViewSeparatorRightInset = 80.f
    
    static let applyButtonCornerRadius = 12.f
  }
  
  
  // MARK: - Types
  
  typealias ViewModel = PopOverSearchFilterViewModel
  
  
  // MARK: - Properties
  
  var viewModel: PopOverSearchFilterViewModel
  public var applyActionHandler: (() -> Void)? = nil
  
  
  // MARK: - UI
  
  @IBOutlet weak var brandSelector: UISegmentedControl!
  @IBOutlet weak var searchFilterTableView: UITableView!
  @IBOutlet weak var applyButton: UIButton!
  
  
  // MARK: - Lifecycle
  
  required init(_ viewModel: PopOverSearchFilterViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    dismiss(animated: true)
  }
  
  required init?(_ coder: NSCoder, _ viewModel: PopOverSearchFilterViewModel) {
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
    setupSearchFilterTableView()
    setupApplyButton()
    setupBrandSelector()
  }
  
  private func setupSearchFilterTableView() {
    registerSearchFilterTableCell()
    searchFilterTableView.tableFooterView = UIView()
    searchFilterTableView.separatorInset  = UIEdgeInsets(top: 0, left: Metric.searchFilterTableViewSeparatorLeftInset, bottom: 0, right: Metric.searchFilterTableViewSeparatorRightInset)
    searchFilterTableView.backgroundColor = .white
  }
  
  private func registerSearchFilterTableCell() {
    let nibName = UINib(nibName: R.nib.searchFilterTableViewCell.name, bundle: nil)
    searchFilterTableView.register(nibName, forCellReuseIdentifier: SearchFilterTableViewCell.identifier)
  }
  
  private func setupApplyButton() {
    applyButton.layer.cornerRadius = Metric.applyButtonCornerRadius
  }
  
  private func setupBrandSelector() {
    brandSelector.setSelectedTextColor(.black)
    brandSelector.setDefaultTextColor(.darkGray)
    brandSelector.selectedSegmentIndex = UserDefaultsManager.searchBrand == .tj ? 0 : 1
  }
  
  
  // MARK: - Binding
  
  private func bind() {
    bindInputs()
    bindOutput()
  }
  
  private func bindInputs() {
    applyButton.rx.tap
      .bind(to: viewModel.input.tapApplyButton)
      .disposed(by: disposeBag)
    
    brandSelector.rx.selectedSegmentIndex
      .distinctUntilChanged()
      .map { index -> KaraokeBrand in
        if index == 0 {
          return .tj
        } else {
          return .kumyoung
        }
      }
      .bind(to: viewModel.input.updateKaraokeBrand)
      .disposed(by: disposeBag)
  }
  
  private func bindOutput() {
    viewModel.output.searchFilterItems
      .bind(to: searchFilterTableView.rx.items(
        cellIdentifier: SearchFilterTableViewCell.identifier,
        cellType: SearchFilterTableViewCell.self)) { index, item, cell in
          cell.configure(item)
        }.disposed(by: disposeBag)
    
    viewModel.output.didTapApplyButton
      .asDriver(onErrorDriveWith: .never())
      .drive(onNext: { [weak self] bool in
        self?.applyActionHandler?()
      })
      .disposed(by: disposeBag)
    
    viewModel.output.dismiss
      .asDriver(onErrorDriveWith: .never())
      .drive(onNext: { [weak self] in
        self?.dismiss(animated: true)
      })
      .disposed(by: disposeBag)
  }
}
