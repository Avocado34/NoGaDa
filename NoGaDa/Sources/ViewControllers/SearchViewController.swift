//
//  SearchViewController.swift
//  NoGaDa
//
//  Created by 이승기 on 2021/09/17.
//

import UIKit

import RxSwift
import RxCocoa
import RxGesture

import Hero
import SafeAreaBrush


final class SearchViewController: BaseViewController, ViewModelInjectable {
  
  // MARK: - Constants
  
  static let identifier = R.storyboard.search.searchStoryboard.identifier
  
  enum Metric {
    static let appbarViewCornerRadius = 28.f
    
    static let searchBoxViewCornerRadius = 12.f
    
    static let searchTextFieldLeftPadding = 12.f
    static let searchTextFieldRightPadding = 80.f
    
    static let filterButtonCornerRadius = 8.f
    static let filterButtonPadding = 8.f
    
    static let backButtonPadding = 4.f
    
    static let clearTextFieldButtonPadding = 6.f
    
    static let searchFilterContentSize = CGSize(width: 240, height: 220)
  }
  
  
  // MARK: - Types
  
  typealias ViewModel = SearchViewModel
  
  
  // MARK: - Properties
  
  var viewModel: SearchViewModel
  
  private var searchTerm: String {
    guard let searchTerm = searchTextField.text?.trimmingCharacters(in: .whitespaces) else {
      return ""
    }
    
    if searchTerm.isEmpty { return "" }
    return searchTerm
  }
  
  
  // MARK: - UI
  
  @IBOutlet weak var appbarView: UIView!
  @IBOutlet weak var appbarViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var appbarTitleLabel: UILabel!
  @IBOutlet weak var backButton: UIButton!
  @IBOutlet weak var searchBoxView: UIView!
  @IBOutlet weak var searchTextField: UITextField!
  @IBOutlet weak var clearTextFieldButton: UIButton!
  @IBOutlet weak var filterButton: UIButton!
  @IBOutlet weak var contentsView: UIView!
  
  private var searchHistoryVC: SearchHistoryViewController?
  private var searchResultVC: SearchResultViewController?
  private var archiveFolderFloatingPanelView: ArchiveFolderFloatingPanelView?
  
  
  // MARK: - LifeCycle
  
  required init(_ viewModel: SearchViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(_ coder: NSCoder, _ viewModel: SearchViewModel) {
    self.viewModel = viewModel
    super.init(coder: coder)
  }
  
  required init?(coder: NSCoder) {
    fatalError("ViewModel has not been implemented")
  }
  
  deinit {
    removeObservers()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    searchTextField.becomeFirstResponder()
  }
  
  
  // MARK: - Overrides
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    view.endEditing(true)
  }
  
  
  // MARK: - Setups
  
  private func setup() {
    setupView()
    bind()
    setupNotifications()
  }
  
  private func setupView() {
    self.hero.isEnabled = true
    
    setupStatusBar()
    setupAppBarView()
    setupAppbarTitleLabel()
    setupSearchBoxView()
    setupSearchTextField()
    setupSearchButton()
    setupBackButton()
    setupClearTextFieldButton()
    setupArchiveFloatingPanelView()
    setupSearchHistoryVC()
    setupSearchResultVC(searchTerm)
  }
  
  private func setupStatusBar() {
    fillSafeArea(position: .top, color: R.color.accentPurple()!, insertAt: 0)
  }
  
  private func setupAppBarView() {
    appbarView.layer.cornerRadius = Metric.appbarViewCornerRadius
    appbarView.layer.cornerCurve = .circular
    appbarView.layer.maskedCorners = CACornerMask([.layerMinXMaxYCorner])
    appbarView.setAppBarShadow()
    appbarViewHeightConstraint.constant = regularAppBarHeight
  }
  
  private func setupAppbarTitleLabel() {
    appbarTitleLabel.hero.id = "appbarTitle"
  }
  
  private func setupSearchBoxView() {
    searchBoxView.layer.cornerRadius = Metric.searchBoxViewCornerRadius
    searchBoxView.layer.masksToBounds = true
    searchBoxView.setSearchBoxShadow()
  }
  
  private func setupSearchTextField() {
    searchTextField.setPlaceholderColor(R.color.textSecondary()!)
    searchTextField.setLeftPadding(width: Metric.searchTextFieldLeftPadding)
    searchTextField.setRightPadding(width: Metric.searchTextFieldRightPadding)
  }
  
  private func setupSearchButton() {
    filterButton.layer.cornerRadius = Metric.filterButtonCornerRadius
    filterButton.setPadding(width: Metric.filterButtonPadding)
    filterButton.setSearchBoxButtonShadow()
  }
  
  private func setupBackButton() {
    backButton.hero.modifiers = [.fade]
    backButton.setPadding(width: Metric.backButtonPadding)
  }
  
  private func setupClearTextFieldButton() {
    clearTextFieldButton.setPadding(width: Metric.clearTextFieldButtonPadding)
  }
  
  private func setupArchiveFloatingPanelView() {
    archiveFolderFloatingPanelView = ArchiveFolderFloatingPanelView(parentViewController: self, delegate: self)
  }
  
  private func setupSearchHistoryVC() {
    let storyboard = UIStoryboard(name: R.storyboard.search.name, bundle: nil)
    let searchHistoryVC = storyboard.instantiateViewController(identifier: SearchHistoryViewController.identifier) { coder -> SearchHistoryViewController in
      let viewModel = SearchHistoryViewModel()
      return .init(coder, viewModel) ?? SearchHistoryViewController(viewModel)
    }
    
    addChild(searchHistoryVC)
    contentsView.addSubview(searchHistoryVC.view)
    searchHistoryVC.didMove(toParent: self)
    searchHistoryVC.view.frame = contentsView.bounds
    
    searchHistoryVC.historyItemSelectActionHandler = { [weak self] term in
      guard let self = self else { return }
      Observable.just(term)
        .bind(to: self.viewModel.input.tapSearchHistory)
        .dispose()
    }
    
    self.searchHistoryVC = searchHistoryVC
  }
  
  private func setupSearchResultVC(_ searchKeyword: String) {
    let storyboard = UIStoryboard(name: R.storyboard.search.name, bundle: nil)
    let searchResultVC = storyboard.instantiateViewController(identifier: SearchResultViewController.identifier) { coder -> SearchResultViewController in
      let viewModel = SearchResultViewModel()
      return .init(coder, viewModel) ?? SearchResultViewController(viewModel)
    }
    
    addChild(searchResultVC)
    contentsView.addSubview(searchResultVC.view)
    searchResultVC.didMove(toParent: self)
    searchResultVC.view.frame = contentsView.bounds
    searchResultVC.view.isHidden = true
    
    searchResultVC.delegate = self
    self.searchResultVC = searchResultVC
  }
  
  
  // MARK: - Binding
  
  private func bind() {
    bindInput()
    bindOutput()
  }
  
  private func bindInput() {
    backButton.rx.tap
      .bind(to: viewModel.input.tapBackButton)
      .disposed(by: disposeBag)

    filterButton.rx.tap
      .bind(to: viewModel.input.tapFilterButton)
      .disposed(by: disposeBag)

    clearTextFieldButton.rx.tap
      .bind(to: viewModel.input.tapClearButton)
      .disposed(by: disposeBag)

    searchTextField.rx.text
      .map { term in
        return term?.description ?? ""
      }
      .bind(to: viewModel.input.editTextField)
      .disposed(by: disposeBag)

    searchTextField.rx.controlEvent([.editingDidEnd])
      .bind(to: viewModel.input.search)
      .disposed(by: disposeBag)
  }

  private func bindOutput() {
    viewModel.output.dismiss
      .subscribe(with: self, onNext: { vc, _ in
        vc.dismiss(animated: true)
      })
      .disposed(by: disposeBag)

    viewModel.output.isSearchFilterShowing
      .subscribe(with: self, onNext: { vc, _ in
        vc.presentSearchFilterPopoverVC()
      })
      .disposed(by: disposeBag)

    viewModel.output.searchTerm
      .subscribe(with: self, onNext: { vc, term in
        if term.isEmpty {
          vc.searchTextField.text = term
        }
      })
      .disposed(by: disposeBag)

    viewModel.output.currentContentType
      .subscribe(with: self, onNext: { vc, contentType in
        vc.replaceContentView(type: contentType)
      })
      .disposed(by: disposeBag)
    
    viewModel.output.isTextFieldFocused
      .distinctUntilChanged()
      .subscribe(with: self, onNext: { vc, isFocused in
        if isFocused {
          vc.searchTextField.becomeFirstResponder()
        } else {
          vc.view.endEditing(true)
        }
      })
      .disposed(by: disposeBag)
    
    viewModel.output.searchTerm
      .subscribe(with: self, onNext: { vc, term in
        vc.searchTextField.text = term
      })
      .disposed(by: disposeBag)
  }
  
  
  // MARK: - Notifications
  
  private func setupNotifications() {
    setupHideKeyboardNotification()
  }
  
  private func setupHideKeyboardNotification() {
    NotificationCenter.default.addObserver(forName: .hideKeyboard, object: nil, queue: .main) { [weak self] _ in
      self?.view.endEditing(true)
    }
  }
  
  private func removeObservers() {
    NotificationCenter.default.removeObserver(self, name: .hideKeyboard, object: nil)
  }
  
  
  // MARK: - Methods
  
  private func dismissKeyboardAndArchivePanel() {
    view.endEditing(true)
    archiveFolderFloatingPanelView?.hide(animated: true)
  }
  
  private func presentSearchFilterPopoverVC() {
    let storyboard = UIStoryboard(name: R.storyboard.search.name, bundle: nil)
    let viewController = storyboard.instantiateViewController(
      identifier: PopOverSearchFilterViewController.identifier,
      creator: { coder -> PopOverSearchFilterViewController in
      let viewModel = PopOverSearchFilterViewModel()
      return .init(coder, viewModel) ?? PopOverSearchFilterViewController(viewModel)
    })
    
    viewController.navigationController?.popoverPresentationController?.backgroundColor = .white
    viewController.modalPresentationStyle = .popover
    viewController.preferredContentSize = Metric.searchFilterContentSize
    viewController.popoverPresentationController?.permittedArrowDirections = .up
    viewController.popoverPresentationController?.sourceRect = filterButton.bounds
    viewController.popoverPresentationController?.sourceView = filterButton
    viewController.presentationController?.delegate = self
    viewController.applyActionHandler = { [weak self] in
      self?.refreshSearchResult()
    }
    
    present(viewController, animated: true, completion: nil)
  }

  
  private func replaceContentView(type: ViewModel.ContentType) {
    guard let searchHistoryVC = searchHistoryVC,
          let searchResultVC = searchResultVC else {
      return
    }
    
    if case .searchHistory = type {
      // Show search history
      searchHistoryVC.view.isHidden = false
      searchResultVC.view.isHidden = true
      searchHistoryVC.refresh()
    }
    if case let .searchResult(term) = type {
      // Show search result
      searchHistoryVC.view.isHidden = true
      searchResultVC.view.isHidden = false
      searchResultVC.setSearchResult(term)
    }
  }
  
  private func refreshSearchResult() {
    Observable.just(Void())
      .bind(to: viewModel.input.search)
      .dispose()
  }
}


// MARK: - UIPopoverPresentationControllerDelegate

extension SearchViewController: UIPopoverPresentationControllerDelegate {
  public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
    return .none
  }
}


// MARK: - SearchResultView Delegate

extension SearchViewController: SearchResultViewDelegate {
  func didSelectSongItem(_ selectedSong: Song) {
    archiveFolderFloatingPanelView?.show(selectedSong)
  }
}


// MARK: - PopUpArchiveFolderView Delegate

extension SearchViewController: PopUpArchiveFolderViewDelegate {
  func didSongAdded() {
    archiveFolderFloatingPanelView?.hide(animated: true)
  }
}
