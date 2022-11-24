//
//  AddSongViewController.swift
//  NoGaDa
//
//  Created by 이승기 on 2021/12/07.
//

import UIKit

import RxSwift
import RxCocoa
import RxGesture
import Hero


@objc protocol AddSongViewDelegate: AnyObject {
  @objc optional func didSongAdded()
}

class AddSongViewController: BaseViewController, ViewModelInjectable {
  
  // MARK: - Constants
  
  static let identifier = R.storyboard.archive.addSongStoryboard.identifier
  
  // MARK: - Types
  
  typealias ViewModel = AddSongViewModel
  
  struct Metric {
    static let confirmButtonCornerRadius = 12.f
    
    static let notificationViewCornerRadius = 12.f
    
    static let songTitleTextFieldLeftPadding = 12.f
    static let songTitleTextFieldRightPadding = 12.f
    
    static let singerTextFieldLeftPadding = 12.f
    static let singerTextFieldRightPadding = 12.f
    
    static let songNumberTextFieldLeftPadding = 12.f
    static let songNumberTextFieldRightPadding = 12.f
    
    static let brandPickerButtonCornerRadius = 12.f
    static let brandPickerButtonBorderWidth = 1.f
    static let brandPickerContentSize = CGSize(width: 140, height: 87)
    // two 44px height of cells - 1px height of separator
    
    static let confirmButtonActiveAlpha = 1.f
    static let confirmButtonInactiveAlpha = 0.2.f
    
    static let keyboardAreaHeight = 150.f
  }
  
  
  // MARK: - Properties
  
  weak var delegate: AddSongViewDelegate?
  var viewModel: ViewModel
  
  
  // MARK: - UI
  
  @IBOutlet weak var exitButton: UIButton!
  @IBOutlet weak var confirmButton: UIButton!
  @IBOutlet weak var notificationView: UIView!
  @IBOutlet weak var songTitleTextField: HighlightingTextfield!
  @IBOutlet weak var singerTextField: HighlightingTextfield!
  @IBOutlet weak var songNumberTextField: HighlightingTextfield!
  @IBOutlet weak var brandPickerButton: UIButton!
  @IBOutlet weak var contentScrollView: UIScrollView!
  @IBOutlet weak var contentView: UIView!
  
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    bind()
  }
  
  
  // MARK: - Overrides
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    view.endEditing(true)
  }
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    
    if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
      traitCollection.performAsCurrent {
        brandPickerButton.layer.borderColor = R.color.lineBasic()!.cgColor
      }
    }
  }
  
  
  // MARK: - Initializers
  
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
  
  
  // MARK: - Setups
  
  private func setup() {
    setupView()
  }
  
  private func setupView() {
    setupExitButton()
    setupConfirmButton()
    setupNotificationView()
    setupSongTitleTextField()
    setupSingerTextField()
    setupSongNumberTextField()
    setupBrandPickerButton()
    setupContentScrollView()
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  private func setupExitButton() {
    exitButton.makeAsCircle()
    exitButton.setExitButtonShadow()
  }
  
  private func setupConfirmButton() {
    confirmButton.layer.cornerRadius = Metric.confirmButtonCornerRadius
    confirmButton.hero.modifiers = [.translate(y: 20), .fade]
  }
  
  private func setupNotificationView() {
    notificationView.layer.cornerRadius = Metric.notificationViewCornerRadius
  }
  
  private func setupSongTitleTextField() {
    songTitleTextField.setLeftPadding(width: Metric.songTitleTextFieldLeftPadding)
    songTitleTextField.setRightPadding(width: Metric.songTitleTextFieldRightPadding)
  }
  
  private func setupSingerTextField() {
    singerTextField.setLeftPadding(width: Metric.singerTextFieldLeftPadding)
    singerTextField.setRightPadding(width: Metric.singerTextFieldRightPadding)
  }
  
  private func setupSongNumberTextField() {
    songNumberTextField.setLeftPadding(width: Metric.songNumberTextFieldLeftPadding)
    songNumberTextField.setRightPadding(width: Metric.songNumberTextFieldRightPadding)
  }
  
  private func setupBrandPickerButton() {
    brandPickerButton.layer.cornerRadius = Metric.brandPickerButtonCornerRadius
    brandPickerButton.layer.borderWidth = Metric.brandPickerButtonBorderWidth
    brandPickerButton.layer.borderColor = R.color.lineBasic()!.cgColor
  }
  
  private func setupContentScrollView() {
    contentScrollView.delegate = self
  }
  
  
  // MARK: - Binds
  
  private func bind() {
    bindInputs()
    bindOutputs()
  }
  
  private func bindInputs() {
    songTitleTextField
      .rx.text
      .orEmpty
      .distinctUntilChanged()
      .bind(to: viewModel.input.songTitle)
      .disposed(by: disposeBag)
    
    songTitleTextField
      .rx.controlEvent(.editingDidEndOnExit)
      .asDriver()
      .drive(with: self, onNext: { vc,_ in
        vc.singerTextField.becomeFirstResponder()
      }).disposed(by: disposeBag)
    
    singerTextField
      .rx.text
      .orEmpty
      .distinctUntilChanged()
      .bind(to: viewModel.input.singerName)
      .disposed(by: disposeBag)
    
    singerTextField
      .rx.controlEvent(.editingDidEndOnExit)
      .asDriver()
      .drive(with: self, onNext: { vc,_ in
        vc.songNumberTextField.becomeFirstResponder()
      }).disposed(by: disposeBag)
    
    songNumberTextField
      .rx.text
      .orEmpty
      .distinctUntilChanged()
      .bind(to: viewModel.input.songNumber)
      .disposed(by: disposeBag)
    
    songNumberTextField
      .rx.controlEvent(.editingDidEndOnExit)
      .asDriver()
      .drive(with: self, onNext: { vc,_ in
        vc.view.endEditing(true)
      }).disposed(by: disposeBag)
    
    contentView
      .rx.tapGesture()
      .when(.recognized)
      .bind(with: self, onNext: { vc,_ in
        vc.view.endEditing(true)
      }).disposed(by: disposeBag)
    
    brandPickerButton
      .rx.tap
      .bind(to: viewModel.input.tapBrandPickerButton)
      .disposed(by: disposeBag)
    
    exitButton
      .rx.tap
      .bind(to: viewModel.input.tapExitButton)
      .disposed(by: disposeBag)
    
    confirmButton
      .rx.tap
      .bind(to: viewModel.input.tapConfirmButton)
      .disposed(by: disposeBag)
  }
  
  private func bindOutputs() {
    viewModel.output
      .confirmButtonActiveState
      .distinctUntilChanged()
      .asDriver(onErrorDriveWith: .never())
      .drive(with: self, onNext: { vc, isAllTextFieldFilled in
        if isAllTextFieldFilled {
          vc.confirmButton.alpha = Metric.confirmButtonActiveAlpha
          vc.confirmButton.isUserInteractionEnabled = true
        } else {
          vc.confirmButton.alpha = Metric.confirmButtonInactiveAlpha
          vc.confirmButton.isUserInteractionEnabled = false
        }
      })
      .disposed(by: disposeBag)
    
    viewModel.output
      .showingBrandPickerView
      .asDriver(onErrorDriveWith: .never())
      .drive(onNext: { [weak self] in
        self?.showBrandPickerVC()
      })
      .disposed(by: disposeBag)
    
    viewModel.output
      .dismiss
      .asDriver(onErrorDriveWith: .never())
      .drive(onNext: { [weak self] in
        self?.dismiss(animated: true)
      })
      .disposed(by: disposeBag)
    
    viewModel.output
      .karaokeBrand
      .distinctUntilChanged()
      .asDriver(onErrorDriveWith: .never())
      .drive(onNext: { [weak self] brand in
        self?.brandPickerButton.setTitle(brand.localizedString, for: .normal)
      })
      .disposed(by: disposeBag)
    
    viewModel.output
      .succeedToAddSong
      .asDriver(onErrorDriveWith: .never())
      .drive(onNext: { [weak self] in
        self?.delegate?.didSongAdded?()
      })
      .disposed(by: disposeBag)
  }
  
  
  // MARK: - Methods
  
  private func showBrandPickerVC() {
    let storyboard = UIStoryboard(name: "Archive", bundle: nil)
    let brandPickerVC = storyboard.instantiateViewController(identifier: "karaokeBrandPickerStoryboard", creator: { coder -> KaraokeBrandPickerViewController in
      let viewModel = KaraokeBrandPickerViewModel()
      return .init(coder, viewModel) ?? KaraokeBrandPickerViewController(viewModel)
    })
    
    brandPickerVC.modalPresentationStyle = .popover
    brandPickerVC.preferredContentSize = Metric.brandPickerContentSize
    brandPickerVC.popoverPresentationController?.permittedArrowDirections = .right
    brandPickerVC.popoverPresentationController?.sourceRect = brandPickerButton.bounds
    brandPickerVC.popoverPresentationController?.sourceView = brandPickerButton
    brandPickerVC.presentationController?.delegate = self
    brandPickerVC.delegate = self
    present(brandPickerVC, animated: true)
  }
  
  @objc
  private func keyboardWillShow(_ sender: Notification) {
    view.frame.origin.y = -Metric.keyboardAreaHeight
  }
  
  @objc
  private func keyboardWillHide(_ sender: Notification) {
    view.frame.origin.y = 0
  }
  
  @objc
  private func didTapDoneButton(_ sender: Any) {
    view.endEditing(true)
  }
}


// MARK: - Extensions

extension AddSongViewController: UIScrollViewDelegate {
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    view.endEditing(true)
  }
}

extension AddSongViewController: UIPopoverPresentationControllerDelegate {
  func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
    return .none
  }
}

extension AddSongViewController: BrandPickerViewDelegate {
  func didBrandSelected(_ selectedBrand: KaraokeBrand) {
    Observable.just(selectedBrand)
      .bind(to: viewModel.input.changeKaraokeBrand)
      .disposed(by: disposeBag)
  }
}
