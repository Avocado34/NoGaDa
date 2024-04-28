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

import SafeAreaBrush
import BISegmentedControl


final class MainViewController: BaseViewController, ViewModelInjectable {
  
  // MARK: - Constants
  
  static let identifier = R.storyboard.main.mainStoryboard.identifier
  
  enum Metric {
    static let appBarCornerRadius = 28.f
    
    static let settingButtonPadding = 4.f
    
    static let searchBoxCornerRadius = 12.f
    static let searchButtonCornerRadius = 8.f
    
    static let archiveShortcutViewCornerRadius = 20.f
    
    static let newUpdateSongTableViewCornerRadius = 12.f 
    
    static let brandSegmentedControlFontSize = 14.f
    static let brandSegmentedControlBarIndicatorHeight = 4.f
  }
  
  
  // MARK: - Types
  
  typealias ViewModel = MainViewModel
  
  
  // MARK: - Properties
  
  var viewModel: ViewModel
  
  
  // MARK: UI
  
  @IBOutlet weak var appBarView: AppBarView!
  @IBOutlet weak var appBarViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var appBarTitleLabel: UILabel!
  @IBOutlet weak var settingButton: UIButton!
  @IBOutlet weak var mainContentScrollView: UIScrollView!
  @IBOutlet weak var mainContentScrollViewContentViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var archiveShortcutView: ArchiveFolderShortcutView!
  @IBOutlet weak var archiveShortcutBackgroundImageView: UIImageView!
  @IBOutlet weak var totalArchivedSongSizeLabel: UILabel!
  @IBOutlet weak var searchBoxView: UIView!
  @IBOutlet weak var searchButton: UIButton!
  @IBOutlet weak var brandSegmentedControl: BISegmentedControl!
  @IBOutlet weak var newUpdateSongTableView: UITableView!
  @IBOutlet weak var newUpdateSongErrorMessageLabel: UILabel!
  @IBOutlet weak var newUpdateSongLoadingIndicator: UIActivityIndicatorView!
  
  private var archiveFolderFloatingView: ArchiveFolderFloatingPanelView?
  
  
  // MARK: - LifeCycle
  
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
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    requestTrackingAuthorization()
    
    // Update constraints
    appBarView.setNeedsLayout()
  }
  
  
  // MARK: - Constraints
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    newUpdateSongTableView.reloadData()
  }
  
  
  // MARK: - Setups
  
  private func setup() {
    setupView()
    bind()
  }
  
  private func setupView() {
    setupStatusBar()
    setupAppBarView()
    setupAppBarTitleLabel()
    setupSettingButton()
    setupMainContentScrollView()
    setupSearchTextField()
    setupSearchButton()
    setupArchiveShortcutBackgroundImageView()
    setupNewUpdateSongTableView()
    setupBrandSegmentedControl()
  }
  
  private func setupStatusBar() {
    fillSafeArea(position: .top, color: R.color.accentPurple()!, insertAt: 0)
  }
  
  private func setupAppBarView() {
    appBarView.backgroundColor = .clear
    appBarView.configure(cornerRadius: Metric.appBarCornerRadius, roundCorners: [.bottomRight])
    appBarView.setAppBarShadow()
    appBarViewHeightConstraint.constant = regularAppBarHeight
    mainContentScrollView.contentInset = UIEdgeInsets(top: regularAppBarHeight,
                                                      left: 0, bottom: 0, right: 0)
    mainContentScrollView.scrollToTop(animated: true)
  }
  
  private func setupAppBarTitleLabel() {
    appBarTitleLabel.hero.id = "appbarTitle"
  }
  
  private func setupSettingButton() {
    settingButton.setPadding(width: Metric.settingButtonPadding)
  }
  
  private func setupMainContentScrollView() {
    mainContentScrollViewContentViewHeightConstraint.constant = view.frame.height
  }
  
  private func setupSearchTextField() {
    searchBoxView.layer.cornerRadius = Metric.searchBoxCornerRadius
    searchBoxView.setSearchBoxShadow()
  }
  
  private func setupSearchButton() {
    searchButton.layer.cornerRadius = Metric.searchButtonCornerRadius
    searchButton.setSearchBoxButtonShadow()
  }
  
  private func setupArchiveShortcutBackgroundImageView() {
    archiveShortcutBackgroundImageView.layer.cornerRadius = Metric.archiveShortcutViewCornerRadius
    archiveShortcutBackgroundImageView.layer.maskedCorners = [.layerMinXMaxYCorner]
  }
  
  private func setupNewUpdateSongTableView() {
    registerNewUpdateSongTableView()
    newUpdateSongTableView.layer.cornerRadius = Metric.newUpdateSongTableViewCornerRadius
    newUpdateSongTableView.tableFooterView = UIView()
    newUpdateSongTableView.separatorStyle = .none
  }
  
  private func registerNewUpdateSongTableView() {
    let nibName = UINib(nibName: R.nib.updatedSongTableViewCell.name, bundle: nil)
    newUpdateSongTableView.register(nibName, forCellReuseIdentifier: UpdatedSongTableViewCell.identifier)
  }
  
  private func setupBrandSegmentedControl() {
    brandSegmentedControl.barIndicatorWidthProportion = 0.7
    brandSegmentedControl.focusedTextColor = R.color.textBasic()!
    brandSegmentedControl.defaultTextColor = R.color.textSecondary()!
    brandSegmentedControl.barIndicatorColor = R.color.accentPink()!
    brandSegmentedControl.barIndicatorHeight = Metric.brandSegmentedControlBarIndicatorHeight
    brandSegmentedControl.defaultFontSize = Metric.brandSegmentedControlFontSize
    brandSegmentedControl.focusedFontSize = Metric.brandSegmentedControlFontSize
    brandSegmentedControl.addItem(title: "tj 업데이트")
    brandSegmentedControl.addItem(title: "금영 업데이트")
  }
  
  
  // MARK: - Binding
  
  private func bind() {
    bindInputs()
    bindOutputs()
    bindMainContentScrollView()
  }
  
  private func bindInputs() {
    Observable.just(Void())
      .bind(to: viewModel.input.viewDidLoad)
      .disposed(by: disposeBag)
    
    self.rx.viewDidAppear
      .map { _ in }
      .bind(to: viewModel.input.viewDidAppear)
      .disposed(by: disposeBag)
    
    Observable.merge(
      searchBoxView.rx.tapGesture().when(.recognized)
        .map { _ in return },
      searchBoxView.rx.longPressGesture().when(.began)
        .map { _ in return },
      searchButton.rx.tap.asObservable()
        .map { _ in return }
    )
    .bind(to: viewModel.input.tapSearchBar)
    .disposed(by: disposeBag)
    
    archiveShortcutView
      .rx.tapGesture()
      .when(.recognized)
      .map { _ in return }
      .bind(to: viewModel.input.tapArchiveFolderView)
      .disposed(by: disposeBag)
    
    settingButton
      .rx.tap
      .map { _ in return }
      .asObservable()
      .bind(to: viewModel.input.tapSettingButton)
      .disposed(by: disposeBag)
    
    newUpdateSongTableView
      .rx.itemSelected
      .bind(to: viewModel.input.tapNewUpdateSongItem)
      .disposed(by: disposeBag)
    
    brandSegmentedControl
      .rx.itemSelected
      .map { index -> KaraokeBrand in
        switch index {
        case 0:
          return KaraokeBrand.tj
        case 1:
          return KaraokeBrand.kumyoung
        default:
          return KaraokeBrand.tj
        }
      }
      .distinctUntilChanged()
      .bind(to: viewModel.input.changeSelectedKaraokeBrand)
      .disposed(by: disposeBag)
  }
  
  private func bindOutputs() {
    viewModel.output.showSearchVC
      .asDriver(onErrorDriveWith: .never())
      .drive(onNext: { [weak self] isShowing in
        if isShowing {
          self?.presentSearchVC()
        }
      })
      .disposed(by: disposeBag)
    
    #if DEBUG
    #else
    viewModel.output
      .showInitialAd
      .asDriver(onErrorDriveWith: .never())
      .drive(with: self, onNext: { vc, _  in
        AdMobManager.shared.presentInitialAd(vc: vc)
      })
      .disposed(by: disposeBag)
    #endif

    viewModel.output.showArchiveFolderVC
      .asDriver(onErrorDriveWith: .never())
      .drive(onNext: { [weak self] isShowing in
        if isShowing {
          self?.presentArchiveFolderVC()
        }
      })
      .disposed(by: disposeBag)
    
    viewModel.output.showSettingVC
      .asDriver(onErrorDriveWith: .never())
      .drive(onNext: { [weak self] isShowing in
        if isShowing {
          self?.presentSettingVC()
        }
      })
      .disposed(by: disposeBag)
    
    viewModel.output.newUpdateSongs
      .bind(to: newUpdateSongTableView.rx.items(
        cellIdentifier: UpdatedSongTableViewCell.identifier,
        cellType: UpdatedSongTableViewCell.self)) { index, item, cell in
          cell.configure(item)
        }
        .disposed(by: disposeBag)
    
    viewModel.output.isLoadingNewUpdateSongs
      .asDriver()
      .drive(with: self, onNext: { vc, isLoading in
        if isLoading {
          vc.newUpdateSongLoadingIndicator.isHidden = false
          vc.newUpdateSongLoadingIndicator.startAnimating()
        } else {
          vc.newUpdateSongLoadingIndicator.isHidden = true
          vc.newUpdateSongLoadingIndicator.stopAnimating()
        }
      })
      .disposed(by: disposeBag)
    
    viewModel.output.newUpdateSongsErrorState
      .asDriver(onErrorDriveWith: .never())
      .drive(with: self, onNext: { vc, message in
        if message.isEmpty {
          vc.newUpdateSongErrorMessageLabel.isHidden = true
        } else {
          vc.newUpdateSongErrorMessageLabel.isHidden = false
          vc.newUpdateSongErrorMessageLabel.text = message
        }
      })
      .disposed(by: disposeBag)
    
    viewModel.output.amountOfSavedSongs
      .asDriver(onErrorDriveWith: .never())
      .drive(onNext: { [weak self] amount in
        self?.totalArchivedSongSizeLabel.text = amount
      })
      .disposed(by: disposeBag)
    
    viewModel.output.showArchiveFolderFloadingView
      .asDriver(onErrorDriveWith: .never())
      .drive(onNext: { [weak self] song in
        self?.showArchiveFolderFloatingView(song)
      })
      .disposed(by: disposeBag)
  }
  
  private func bindMainContentScrollView() {
    mainContentScrollView.rx.contentOffset
      .asDriver()
      .drive(with: self, onNext: { vc, offset in
        let compactAppBarHeight = vc.compactAppBarHeight
        let regularAppBarHeight = vc.regularAppBarHeight
        let changedY = offset.y + regularAppBarHeight
        
        if -regularAppBarHeight < offset.y {
          // Shrink AppBar
          if regularAppBarHeight - changedY >= compactAppBarHeight {
            let modifiedAppbarHeight: CGFloat = regularAppBarHeight - changedY
            vc.appBarViewHeightConstraint.constant = modifiedAppbarHeight
            
            let appbarTitleLabelAlpha: CGFloat = 1 - (regularAppBarHeight - modifiedAppbarHeight) / (regularAppBarHeight - compactAppBarHeight)
            vc.appBarTitleLabel.alpha = appbarTitleLabelAlpha
            vc.settingButton.alpha = appbarTitleLabelAlpha
          } else {
            vc.appBarViewHeightConstraint.constant = compactAppBarHeight
            vc.appBarTitleLabel.alpha = 0
            vc.settingButton.alpha = 0
          }
        } else {
          // Stretch AppBar
          vc.appBarViewHeightConstraint.constant = regularAppBarHeight - changedY * 0.2
          vc.appBarTitleLabel.alpha = 1
          vc.settingButton.alpha = 1
        }
      }).disposed(by: disposeBag)
  }
  
  
  // MARK: - Methods
  
  private func presentSearchVC() {
    let storyboard = UIStoryboard(name: R.storyboard.search.name, bundle: nil)
    let searchVC = storyboard.instantiateViewController(identifier: SearchViewController.identifier) { coder -> SearchViewController in
      let viewModel = SearchViewModel()
      return .init(coder, viewModel) ?? SearchViewController(.init())
    }
    
    HapticFeedbackManager.playImpactFeedback(.light)
    searchVC.modalPresentationStyle = .fullScreen
    present(searchVC, animated: true)
  }
  
  private func presentArchiveFolderVC() {
    let storyboard = UIStoryboard(name: R.storyboard.archive.name, bundle: nil)
    let archiveVC = storyboard.instantiateViewController(identifier: ArchiveFolderViewController.identifier) { coder -> ArchiveFolderViewController in
      let viewModel = ArchiveFolderViewModel()
      return .init(coder, viewModel) ?? ArchiveFolderViewController(viewModel)
    }
    
    archiveVC.delegate = self
    archiveVC.modalPresentationStyle = .fullScreen
    present(archiveVC, animated: true, completion: nil)
  }
  
  private func presentSettingVC() {
    let storyboard = UIStoryboard(name: R.storyboard.setting.name, bundle: nil)
    let viewController = storyboard.instantiateViewController(identifier: SettingViewController.identifier) { coder -> SettingViewController in
      let viewModel = SettingViewModel()
      return SettingViewController(coder, viewModel) ?? .init(viewModel)
    }
    
    present(viewController, animated: true, completion: nil)
  }
  
  private func showArchiveFolderFloatingView(_ selectedSong: Song) {
    archiveFolderFloatingView?.hide(animated: false)
    archiveFolderFloatingView = ArchiveFolderFloatingPanelView(parentViewController: self, delegate: self)
    archiveFolderFloatingView?.show(selectedSong)
  }
}


// MARK: - PopUpArchiveFolderViewDelegate

extension MainViewController: PopUpArchiveFolderViewDelegate {
  public func didSongAdded() {
    archiveFolderFloatingView?.hide(animated: true)
    Observable.just(Void())
      .bind(to: viewModel.input.didSongAdded)
      .dispose()
  }
}


// MARK: - ArchiveFolderListViewDelegate

extension MainViewController: ArchiveFolderListViewDelegate {
  public func didFileChanged() {
    Observable.just(Void())
      .bind(to: viewModel.input.didFileChanged)
      .dispose()
  }
}
