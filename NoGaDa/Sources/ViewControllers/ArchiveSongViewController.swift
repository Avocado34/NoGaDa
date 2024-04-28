//
//  FolderViewController.swift
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


@objc protocol ArchiveSongListViewDelegate: AnyObject {
  @objc optional func didFolderEdited()
}

final class ArchiveSongViewController: BaseViewController, ViewModelInjectable {
  
  // MARK: - Constants
  
  static let identifier = R.storyboard.archive.archiveSongStoryboard.identifier
  
  struct Metric {
    static let archiveSongTableViewTopInset = 36.f
    
    static let archiveSongTableViewCornerRadius = 20.f
    static let archiveSongTableViewBottomInset = 100.f
    
    static let folderTitleTextFieldCornerRadius = 12.f
    static let folderTitleTextFieldLeftPadding = 16.f
    static let folderTitleTextFieldRightPadding = 16.f
    
    static let folderTitleEmojiTextFieldCornerRadius = 16.f
    
    static let addSongButtonShadowRadius = 20.f
    static let addSongButtonShadowOpacity: Float = 0.25
  }
  
  
  // MARK: - Types
  
  typealias ViewModel = ArchiveSongViewModel
  
  
  // MARK: - Properties
  
  weak var delegate: ArchiveSongListViewDelegate?
  var viewModel: ViewModel
  

  // MARK: - UI
  
  @IBOutlet weak var appBarView: UIView!
  @IBOutlet weak var appBarViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var exitButton: UIButton!
  @IBOutlet weak var folderTitleEmojiTextField: EmojiTextField!
  @IBOutlet weak var folderTitleTextField: UITextField!
  @IBOutlet weak var archiveSongTableView: UITableView!
  @IBOutlet weak var addSongButton: UIButton!

  private var songOptionFloatingPanelView: SongOptionFloatingPanelView?
  
  
  // MARK: - Lifecycle
  
  required init(_ viewModel: ArchiveSongViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(_ coder: NSCoder, _ viewModel: ArchiveSongViewModel) {
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
  
  
  // MARK: - Overrides
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    archiveSongTableView.reloadData()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    view.endEditing(true)
  }

  
  // MARK: - Setups
  
  private func setup() {
    setupView()
  }
  
  private func setupView() {
    setupStatusBar()
    setupAppBarView()
    setupExitButton()
    setupArchiveSongTableView()
    setupFolderTitleTextField()
    setupTitleEmojiTextField()
    setupAddSongButton()
    setupSongOptionFloatingPanelView()
  }
  
  private func setupStatusBar() {
    fillSafeArea(position: .top, color: R.color.accentColor()!, insertAt: 0)
  }
  
  private func setupAppBarView() {
    appBarView.layer.cornerRadius = 28
    appBarView.layer.maskedCorners = CACornerMask([.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
    appBarView.setAppBarShadow()
    appBarViewHeightConstraint.constant = compactAppBarHeight
  }
  
  private func setupExitButton() {
    exitButton.makeAsCircle()
    exitButton.setExitButtonShadow()
  }
  
  private func setupArchiveSongTableView() {
    registerArchiveSongTableCell()
    archiveSongTableView.tableFooterView = UIView()
    archiveSongTableView.separatorStyle = .none
    archiveSongTableView.layer.cornerRadius = Metric.archiveSongTableViewCornerRadius
    archiveSongTableView.contentInset = UIEdgeInsets(top: Metric.archiveSongTableViewTopInset, left: 0, bottom: Metric.archiveSongTableViewBottomInset, right: 0)
    
    archiveSongTableView.rx.setDelegate(self)
      .disposed(by: disposeBag)
  }
  
  private func registerArchiveSongTableCell() {
    let songCellNibName = UINib(nibName: R.nib.songTableViewCell.name, bundle: nil)
    archiveSongTableView.register(songCellNibName, forCellReuseIdentifier: SongTableViewCell.identifier)
  }
  
  private func setupFolderTitleTextField() {
    folderTitleTextField.layer.cornerRadius = Metric.folderTitleTextFieldCornerRadius
    folderTitleTextField.setLeftPadding(width: Metric.folderTitleTextFieldLeftPadding)
    folderTitleTextField.setRightPadding(width: Metric.folderTitleTextFieldRightPadding)
    folderTitleTextField.setSearchBoxShadow()
    folderTitleTextField.hero.modifiers = [.fade, .translate(y: -12)]
    folderTitleTextField.text = viewModel.folderTitle
  }
  
  private func setupTitleEmojiTextField() {
    folderTitleEmojiTextField.layer.cornerRadius = Metric.folderTitleEmojiTextFieldCornerRadius
    folderTitleEmojiTextField.setSearchBoxShadow()
    folderTitleEmojiTextField.hero.modifiers = [.fade, .translate(y: -12)]
    folderTitleEmojiTextField.text = viewModel.folderTitleEmoji
  }
  
  private func setupAddSongButton() {
    addSongButton.makeAsCircle()
    addSongButton.hero.modifiers = [.fade, .translate(y: view.safeAreaInsets.bottom + 28)]
    addSongButton.layer.shadowColor = R.color.backgroundBasic()!.cgColor
    addSongButton.layer.shadowOffset = .zero
    addSongButton.layer.shadowRadius = Metric.addSongButtonShadowRadius
    addSongButton.layer.shadowOpacity = Metric.addSongButtonShadowOpacity
  }
  
  private func setupSongOptionFloatingPanelView() {
    songOptionFloatingPanelView = SongOptionFloatingPanelView(parentViewController: self, delegate: self)
  }
  
  
  // MARK: - Binding
  
  private func bind() {
    bindInputs()
    bindOutputs()
    bindAppBarView()
    bindFolderTitleEmojiTextField()
  }
  
  private func bindInputs() {
    Observable.just(Void())
      .bind(to: viewModel.input.viewDidLoad)
      .disposed(by: disposeBag)
    
    self.rx.viewWillDisappear
      .map { _ in }
      .bind(to: viewModel.input.viewWillDisappear)
      .disposed(by: disposeBag)
    
    exitButton
      .rx.tap
      .bind(to: viewModel.input.tapExitButton)
      .disposed(by: disposeBag)
    
    addSongButton
      .rx.tap
      .bind(to: viewModel.input.tapAddSongButton)
      .disposed(by: disposeBag)
    
    archiveSongTableView
      .rx.itemSelected
      .bind(to: viewModel.input.tapSongItem)
      .disposed(by: disposeBag)
    
    folderTitleEmojiTextField
      .rx.text
      .orEmpty
      .bind(to: viewModel.input.folderEmoji)
      .disposed(by: disposeBag)
    
    folderTitleTextField
      .rx.text
      .orEmpty
      .bind(to: viewModel.input.folderTitle)
      .disposed(by: disposeBag)
  }
  
  private func bindOutputs() {
    viewModel.output.archiveSongs
      .bind(to: archiveSongTableView.rx.items(
        cellIdentifier: SongTableViewCell.identifier,
        cellType: SongTableViewCell.self)) { _, item, cell in
          cell.configure(item.asSongType())
        }
        .disposed(by: disposeBag)
    
    viewModel.output.dismiss
      .asDriver(onErrorDriveWith: .never())
      .drive(onNext: { [weak self] in
        self?.dismiss(animated: true)
      })
      .disposed(by: disposeBag)
    
    viewModel.output.showingAddSongVC
      .asDriver(onErrorDriveWith: .never())
      .drive(onNext: { [weak self] currentFolder in
        self?.presentAddSongVC(currentFolder)
      })
      .disposed(by: disposeBag)
    
    viewModel.output.showingSongOptionFloatingPanelView
      .asDriver(onErrorDriveWith: .never())
      .drive(onNext: { [weak self] song in
        self?.songOptionFloatingPanelView?.show(song)
      })
      .disposed(by: disposeBag)
    
    viewModel.output.didFolderEdited
      .asDriver(onErrorDriveWith: .never())
      .drive(onNext: { [weak self] in
        self?.delegate?.didFolderEdited?()
      })
      .disposed(by: disposeBag)
  }
  
  private func bindFolderTitleEmojiTextField() {
    folderTitleEmojiTextField.rx.text
      .asDriver()
      .drive(with: self) { vc, string in
        guard let string = string else { return }
        if string.count >= 1 {
          guard let inputChar = string.last else { return }
          
          if !inputChar.isEmoji {
            vc.folderTitleEmojiTextField.text = ""
          } else {
            vc.folderTitleEmojiTextField.text = inputChar.description
          }
        }
      }.disposed(by: disposeBag)
  }
  
  private func bindAppBarView() {
    archiveSongTableView.rx.contentOffset
      .asDriver()
      .drive(with: self, onNext: { vc, offset in
        let changedY = offset.y + Metric.archiveSongTableViewTopInset
        let newAppBarHeight = vc.compactAppBarHeight - (changedY * 0.2)
        
        if newAppBarHeight >= vc.compactAppBarHeight {
          vc.appBarViewHeightConstraint.constant = newAppBarHeight
        }
      }).disposed(by: disposeBag)
  }
  
  
  // MARK: - Methods
  
  private func presentAddSongVC(_ archiveFolder: ArchiveFolder) {
    let storyboard = UIStoryboard(name: R.storyboard.archive.name, bundle: nil)
    let addSongVC = storyboard.instantiateViewController(identifier: AddSongViewController.identifier) { coder -> AddSongViewController in
      let viewModel = AddSongViewModel(targetFolderId: archiveFolder.id)
      return .init(coder, viewModel) ?? AddSongViewController(viewModel)
    }
    
    addSongVC.modalPresentationStyle = .fullScreen
    addSongVC.delegate = self
    present(addSongVC, animated: true, completion: nil)
  }
}


// MARK: - UITableViewDelegate

extension ArchiveSongViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { [weak self] _, _, _ in
      guard let self = self else { return }
      Observable.just(indexPath)
        .bind(to: self.viewModel.input.deleteSongItem)
        .dispose()
    }
    let actions = [deleteAction]
    
    return .init(actions: actions)
  }
  
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    view.endEditing(true)
  }
}


// MARK: - UITableViewDelegate

extension ArchiveSongViewController: AddSongViewDelegate {
  func didSongAdded() {
    Observable.just(Void())
      .bind(to: viewModel.input.songItemEdited)
      .dispose()
  }
}


// MARK: - PopUpSongOptionViewDelegate

extension ArchiveSongViewController: PopUpSongOptionViewDelegate {
  func didSelectedSongRemoved() {
    songOptionFloatingPanelView?.hide(animated: true)
    Observable.just(Void())
      .bind(to: viewModel.input.songItemEdited)
      .dispose()
  }
  
  func didSelectedItemMoved() {
    songOptionFloatingPanelView?.hide(animated: true)
    Observable.just(Void())
      .bind(to: viewModel.input.songItemEdited)
      .dispose()
  }
}
