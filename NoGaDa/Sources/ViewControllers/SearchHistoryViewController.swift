//
//  SearchHistoryViewController.swift
//  NoGaDa
//
//  Created by 이승기 on 2021/10/09.
//

import UIKit

import RxSwift
import RxCocoa


final class SearchHistoryViewController: BaseViewController, ViewModelInjectable {
  
  // MARK: - Constants
  
  static let identifier = R.storyboard.search.searchHistoryStoryboard.identifier
  
  
  // MARK: - Types
  
  typealias ViewModel = SearchHistoryViewModel

  
  // MARK: - Properties
  
  var viewModel: ViewModel
  public var historyItemSelectActionHandler: ((_ term: String) -> Void)? = nil
  
  
  // MARK: - UI
  
  @IBOutlet weak var searchHistoryTableView: UITableView!
  @IBOutlet weak var searchHistoryPlaceholderLabel: UILabel!
  @IBOutlet weak var clearHistoryButton: UIButton!
  
  
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
  }
  
  
  // MARK: - Setups
  
  private func setup() {
    setupView()
    bind()
  }
  
  private func setupView() {
    setupSearchHistoryTableView()
  }
  
  private func setupSearchHistoryTableView() {
    registerSearchHistoryTableView()
    searchHistoryTableView.separatorStyle = .none
    searchHistoryTableView.tableFooterView = UIView()
  }
  
  private func registerSearchHistoryTableView() {
    let nibName = UINib(nibName: R.nib.searchHistoryTableViewCell.name, bundle: nil)
    searchHistoryTableView.register(nibName, forCellReuseIdentifier: SearchHistoryTableViewCell.identifier)
  }
  
  
  // MARK: - Binding
  
  private func bind() {
    bindInputs()
    bindOutputs()
  }
  
  private func bindInputs() {
    Observable.just(Void())
      .bind(to: viewModel.input.viewDidLoad)
      .disposed(by: disposeBag)
    
    clearHistoryButton
      .rx.tap
      .bind(to: viewModel.input.tapClearHistoryButton)
      .disposed(by: disposeBag)
    
    searchHistoryTableView
      .rx.itemSelected
      .bind(to: viewModel.input.tapHistoryItem)
      .disposed(by: disposeBag)
    
    searchHistoryTableView.rx.didScroll
      .asDriver()
      .drive(onNext: { _ in
        NotificationCenter.default.post(name: .hideKeyboard, object: nil)
      })
      .disposed(by: disposeBag)
  }
  
  private func bindOutputs() {
    viewModel.output
      .searchHistories
      .bind(to: searchHistoryTableView.rx.items(
        cellIdentifier: SearchHistoryTableViewCell.identifier,
        cellType: SearchHistoryTableViewCell.self)) { [weak self] index, item, cell in
          guard let self = self else { return }
          cell.configure(item) { [weak self] in
            self?.viewModel.deleteHistory(index)
          }
        }.disposed(by: disposeBag)
    
    viewModel.output
      .searchHistories
      .subscribe(with: self, onNext: { vc, histories in
        if histories.isEmpty {
          vc.searchHistoryPlaceholderLabel.isHidden = false
        } else {
          vc.searchHistoryPlaceholderLabel.isHidden = true
        }
      })
      .disposed(by: disposeBag)
    
    viewModel.output
      .didTapHistoryItem
      .asDriver(onErrorDriveWith: .never())
      .drive(with: self, onNext: { vc, historyItem in
        let term = historyItem.keyword
        vc.historyItemSelectActionHandler?(term)
      })
      .disposed(by: disposeBag)
  }
  
  
  // MARK: - Public
  
  public func refresh() {
    Observable.just(Void())
      .bind(to: viewModel.input.refresh)
      .dispose()
  }
}
