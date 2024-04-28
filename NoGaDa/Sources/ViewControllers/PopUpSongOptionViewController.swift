//
//  PopUpSongOptionViewController.swift
//  NoGaDa
//
//  Created by 이승기 on 2021/12/14.
//

import UIKit

import RxSwift
import RxCocoa


@objc protocol PopUpSongOptionViewDelegate: AnyObject {
  @objc optional func didSelectedSongRemoved()
  @objc optional func didSelectedItemMoved()
}

final class PopUpSongOptionViewController: BaseViewController, ViewModelInjectable {
  
  // MARK: - Constants
  
  static let identifier = R.storyboard.archive.popUpSongOptionStoryboard.identifier
  
  struct Metric {
    static let songThumbnailImageViewCornerRadius = 12.f
  }
  
  
  // MARK: - Types
  
  typealias ViewModel = PopUpSongOptionViewModel
  
  
  // MARK: - Properties
  
  weak var delegate: PopUpSongOptionViewDelegate?
  var viewModel: PopUpSongOptionViewModel
  public var exitButtonAction: () -> Void = {}
  
  
  // MARK: - UI
  
  @IBOutlet weak var songThumbnailImageView: UIImageView!
  @IBOutlet weak var exitButton: UIButton!
  @IBOutlet weak var songTitleLabel: UILabel!
  @IBOutlet weak var singerLabel: UILabel!
  @IBOutlet weak var optionTableView: UITableView!
  
  private var parentVC: UIViewController
  private var archiveFolderFloatingPanelView: ArchiveFolderFloatingPanelView?
  
  
  // MARK: - Lifecycle
  
  required init(_ viewModel: ViewModel) {
    self.viewModel = viewModel
    self.parentVC = UIViewController()
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(_ coder: NSCoder, parentVC: UIViewController, viewModel: ViewModel) {
    self.parentVC = parentVC
    self.viewModel = viewModel
    super.init(coder: coder)
  }
  
  required init?(_ coder: NSCoder, _ viewModel: PopUpSongOptionViewModel) {
    fatalError("Parent ViewController has not been implemented")
  }
  
  required init?(coder: NSCoder) {
    fatalError("ViewModel has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    bind()
  }
  
  
  // MARK: - Setups
  
  private func setupView() {
    setupExitButton()
    setupSongThumbnailImageView()
    setupSongTitleLabel()
    setupSingerLabel()
    setupOptionTableView()
    setupArchiveFolderFloatingPanelView()
  }
  
  private func setupExitButton() {
    exitButton.makeAsCircle()
  }
  
  private func setupSongThumbnailImageView() {
    songThumbnailImageView.layer.cornerRadius = Metric.songThumbnailImageViewCornerRadius
  }
  
  private func setupSongTitleLabel() {
    songTitleLabel.text = viewModel.selectedSong.title
  }
  
  private func setupSingerLabel() {
    singerLabel.text = viewModel.selectedSong.singer
  }
  
  private func setupOptionTableView() {
    optionTableView.separatorStyle = .none
    optionTableView.tableFooterView = UIView()
    
    let nibName = UINib(nibName: R.nib.popUpSongOptionTableViewCell.name, bundle: nil)
    optionTableView.register(nibName, forCellReuseIdentifier: PopUpSongOptionTableViewCell.identifier)
    optionTableView.dataSource = self
    optionTableView.delegate = self
  }
  
  private func setupArchiveFolderFloatingPanelView() {
    archiveFolderFloatingPanelView = ArchiveFolderFloatingPanelView(parentViewController: parentVC, delegate: self)
  }
  
  
  // MARK: - Binding
  
  private func bind() {
    bindInputs()
    bindOutputs()
  }
  
  private func bindInputs() {
    exitButton
      .rx.tap
      .bind(to: viewModel.input.tapExitButton)
      .disposed(by: disposeBag)
    
    optionTableView
      .rx.itemSelected
      .bind(to: viewModel.input.tapOptionItem)
      .disposed(by: disposeBag)
  }
  
  private func bindOutputs() {
    viewModel.output
      .dismiss
      .asDriver(onErrorDriveWith: .never())
      .drive(onNext: { [weak self] in
        self?.exitButtonAction()
      })
      .disposed(by: disposeBag)
    
    viewModel.output
      .showingFolderFloatingPanelView
      .asDriver(onErrorDriveWith: .never())
      .drive(with: self, onNext: { vc, song in
        let song = song.asSongType()
        vc.archiveFolderFloatingPanelView?.show(song)
      })
      .disposed(by: disposeBag)
    
    viewModel.output
      .showingDeleteSongAlert
      .asDriver(onErrorDriveWith: .never())
      .drive(with: self, onNext: { vc, song in
        vc.presentRemoveAlert(song)
      })
      .disposed(by: disposeBag)
    
    viewModel.output
      .didSelectedSongItemEdited
      .asDriver(onErrorDriveWith: .never())
      .drive(with: self, onNext: { vc, _ in
        vc.archiveFolderFloatingPanelView?.hide(animated: true)
        vc.delegate?.didSelectedItemMoved?()
      })
      .disposed(by: disposeBag)
  }
  
  
  // MARK: - Methods
  
  private func presentArchiveFolderVC(_ selectedSong: Song) {
    let storyboard = UIStoryboard(name: R.storyboard.folder.name, bundle: nil)
    let archiveFolderVC = storyboard.instantiateViewController(identifier: PopUpArchiveFolderViewController.identifier) { coder -> PopUpArchiveFolderViewController in
      let viewModel = PopUpArchiveFolderViewModel()
      return .init(coder, viewModel) ?? PopUpArchiveFolderViewController(.init())
    }
    
    archiveFolderVC.delegate = self
    present(archiveFolderVC, animated: true, completion: nil)
  }
  
  private func presentRemoveAlert(_ song: ArchiveSong) {
    let removeAlert = UIAlertController(title: "삭제", message: "정말 「\(song.title)」 를 삭제하시겠습니까?", preferredStyle: .alert)
    
    let confirmAction = UIAlertAction(title: "확인", style: .default) { [weak self] action in
      guard let self = self else { return }
      Observable.just(Void())
        .bind(to: self.viewModel.input.deleteSong)
        .dispose()
    }
    
    let cancelAction = UIAlertAction(title: "취소", style: .destructive, handler: nil)
    
    removeAlert.addAction(confirmAction)
    removeAlert.addAction(cancelAction)
    
    present(removeAlert, animated: true)
  }
}


// MARK: - UITableViewDataSource, UITableViewDelegate

extension PopUpSongOptionViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfRowsInSection(viewModel.sectionCount)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: PopUpSongOptionTableViewCell.identifier,
      for: indexPath) as? PopUpSongOptionTableViewCell else { return UITableViewCell() }
    let item = viewModel.optionAtIndex(indexPath)
    cell.configure(item)
    return cell
  }
}


// MARK: - PopUpArchiveFolderViewDelegate

extension PopUpSongOptionViewController: PopUpArchiveFolderViewDelegate {
  func didSongAdded() {
    archiveFolderFloatingPanelView?.hide(animated: true)
    archiveFolderFloatingPanelView = nil
    Observable.just(Void())
      .bind(to: viewModel.input.deleteSong)
      .disposed(by: disposeBag)
  }
}
