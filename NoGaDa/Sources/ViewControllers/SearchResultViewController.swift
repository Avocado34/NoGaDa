//
//  SearchResultViewController.swift
//  NoGaDa
//
//  Created by 이승기 on 2021/10/09.
//

import UIKit

import RxSwift
import RxCocoa


protocol SearchResultViewDelegate: AnyObject {
  func didSelectSongItem(_ selectedSong: Song)
}

final class SearchResultViewController: BaseViewController, ViewModelInjectable {
  
  // MARK: - Constants
  
  static let identifier = R.storyboard.search.searchResultStoryboard.identifier
  struct Metric {
    static let searchResultTableViewTopInset = 24.f
  }

  
  // MARK: - Types
  
  typealias ViewModel = SearchResultViewModel
  
  
  // MARK: - Properties
  
  weak var delegate: SearchResultViewDelegate?
  var viewModel: ViewModel

  
  // MARK: - UI
  
  @IBOutlet weak var searchResultContentView: UIView!
  @IBOutlet weak var searchResultTableView: UITableView!
  @IBOutlet weak var searchResultMessageLabel: UILabel!
  @IBOutlet weak var searchLoadingIndicator: UIActivityIndicatorView!
  
  
  // MARK: - Lifecycle
  
  required init(_ viewModel: SearchResultViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    dismiss(animated: true)
  }
  
  required init?(_ coder: NSCoder, _ viewModel: SearchResultViewModel) {
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
  
  
  // MARK: - Overrides
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    searchResultTableView.reloadData()
  }
  
  
  // MARK: - Setups
  
  private func setup() {
    setupView()
  }
  
  private func setupView() {
    setupSearchResultTableView()
    setupLoadingIndicatorView()
    setupSearchResultPlaceholderLabel()
  }
  
  private func setupSearchResultTableView() {
    registerSearchResultTableView()
    searchResultTableView.tableFooterView = UIView()
    searchResultTableView.separatorStyle = .none
    
    searchResultTableView.clipsToBounds = false
    searchResultTableView.contentInset = .init(
      top: Metric.searchResultTableViewTopInset,
      left: 0,
      bottom: 0,
      right: 0)
  }
  
  private func registerSearchResultTableView() {
    let nibName = UINib(nibName: R.nib.songTableViewCell.name, bundle: nil)
    searchResultTableView.register(nibName, forCellReuseIdentifier: SongTableViewCell.identifier)
  }
  
  private func setupLoadingIndicatorView() {
    searchLoadingIndicator.stopAnimatingAndHide()
  }
  
  private func setupSearchResultPlaceholderLabel() {
    searchResultMessageLabel.text = "검색창에 제목이나 가수명으로 노래를 검색하세요!"
    searchResultMessageLabel.isHidden = true
  }
  
  
  // MARK: - Binding
  
  private func bind() {
    bindInputs()
    bindOutputs()
  }
  
  private func bindInputs() {
    searchResultTableView
      .rx.itemSelected
      .bind(to: viewModel.input.tapSongItem)
      .disposed(by: disposeBag)
    
    searchResultTableView.rx.didScroll
      .asDriver()
      .drive(onNext: { _ in
        NotificationCenter.default.post(name: .hideKeyboard, object: nil)
      })
    .disposed(by: disposeBag)
  }
  
  private func bindOutputs() {
    viewModel.output
      .searchResultSongs
      .bind(to: searchResultTableView.rx.items(
        cellIdentifier: SongTableViewCell.identifier,
        cellType: SongTableViewCell.self)) { [weak self] index, item, cell in
          guard let self = self else { return }
          let searchTerm = self.viewModel.searchKeyword
          cell.configure(item, term: searchTerm)
        }
        .disposed(by: disposeBag)
    
    viewModel.output
      .didSelectSongItem
      .asDriver(onErrorDriveWith: .never())
      .drive(with: self, onNext: { vc, selectedSong in
        vc.delegate?.didSelectSongItem(selectedSong)
      })
      .disposed(by: disposeBag)
    
    viewModel.output
      .isLoading
      .asDriver(onErrorDriveWith: .never())
      .drive(with: self, onNext: { vc, isLoading in
        if isLoading {
          vc.searchLoadingIndicator.isHidden = false
          vc.searchLoadingIndicator.startAnimating()
        } else {
          vc.searchLoadingIndicator.isHidden = true
          vc.searchLoadingIndicator.stopAnimating()
        }
      })
      .disposed(by: disposeBag)
    
    viewModel.output
      .searchResultErrorState
      .asDriver(onErrorDriveWith: .never())
      .drive(with: self, onNext: { vc, errorMessage in
        if errorMessage.isEmpty {
          vc.searchResultMessageLabel.isHidden = true
        } else {
          vc.searchResultMessageLabel.isHidden = false
          vc.searchResultMessageLabel.text = errorMessage
        }
      })
      .disposed(by: disposeBag)
  }
  
  
  // MARK: - Public
  
  public func setSearchResult(_ term: String) {
    Observable.just(term)
      .bind(to: viewModel.input.search)
      .disposed(by: disposeBag)
  }
}
