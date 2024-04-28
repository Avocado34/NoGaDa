//
//  BrandPickerViewController.swift
//  NoGaDa
//
//  Created by 이승기 on 2022/01/05.
//

import UIKit

import RxSwift
import RxCocoa


protocol BrandPickerViewDelegate: AnyObject {
  func didBrandSelected(_ selectedBrand: KaraokeBrand)
}

final class KaraokeBrandPickerViewController: BaseViewController, ViewModelInjectable {
  
  // MARK: - Constants
  
  static let identifier = R.storyboard.archive.karaokeBrandPickerStoryboard.identifier
  
  struct Metric {
    static let brandPickerTableViewSeparatorLeftInset = 8.f
    static let brandPickerTableviewSeparatorRightInset = 8.f
  }
  
  
  // MARK: - Types
  
  typealias ViewModel = KaraokeBrandPickerViewModel
  
  
  // MARK: - Properties
  
  weak var delegate: BrandPickerViewDelegate?
  var viewModel: KaraokeBrandPickerViewModel
  
  
  // MARK: - UI
  
  @IBOutlet weak var brandPickerTableView: UITableView!
  
  
  // MARK: - Lifecycle
  
  required init(_ viewModel: ViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(_ coder: NSCoder, _ viewModel: ViewModel) {
    self.viewModel = viewModel
    super.init(coder: coder)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
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
    setupBrandPickerTableView()
  }
  
  private func setupBrandPickerTableView() {
    registerBrandPickerTableViewCell()
    brandPickerTableView.tableFooterView = UIView()
    brandPickerTableView.separatorStyle = .singleLine
    brandPickerTableView.separatorInset = UIEdgeInsets(top: 0, left: Metric.brandPickerTableViewSeparatorLeftInset, bottom: 0, right: Metric.brandPickerTableviewSeparatorRightInset)
    brandPickerTableView.showsVerticalScrollIndicator = false
    brandPickerTableView.isScrollEnabled = false
  }
  
  private func registerBrandPickerTableViewCell() {
    let nibName = UINib(nibName: R.nib.karaokeBrandPickerTableViewCell.name, bundle: nil)
    brandPickerTableView.register(nibName, forCellReuseIdentifier: KaraokeBrandPickerTableViewCell.identifier)
  }
  
  
  // MARK: - Binding
  
  private func bind() {
    bindInputs()
    bindOutputs()
  }
  
  private func bindInputs() {
    brandPickerTableView
      .rx.itemSelected
      .bind(to: viewModel.input.tapKaraokeBrandItem)
      .disposed(by: disposeBag)
  }
  
  private func bindOutputs() {
    viewModel.output
      .karaokeBrands
      .bind(to: brandPickerTableView.rx.items(cellIdentifier: KaraokeBrandPickerTableViewCell.identifier, cellType: KaraokeBrandPickerTableViewCell.self)) { index, brand, cell in
        cell.brandNameLabel.text = brand.localizedString
      }
      .disposed(by: disposeBag)
    
    viewModel.output
      .didTapKaraokeBrandItem
      .asDriver(onErrorDriveWith: .never())
      .drive(with: self, onNext: { vc, brand in
        vc.delegate?.didBrandSelected(brand)
      })
      .disposed(by: disposeBag)
    
    viewModel.output
      .dismiss
      .asDriver(onErrorDriveWith: .never())
      .drive(with: self, onNext: { vc, _ in
        vc.dismiss(animated: true)
      })
      .disposed(by: disposeBag)
  }
}
