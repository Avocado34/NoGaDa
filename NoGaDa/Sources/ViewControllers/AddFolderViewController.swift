//
//  AddFolderViewController.swift
//  NoGaDa
//
//  Created by 이승기 on 2021/09/17.
//

import UIKit

import RxSwift
import RxCocoa
import RxGesture


@objc protocol AddFolderViewDelegate: AnyObject {
  @objc func didFolderAdded()
}

final class AddFolderViewController: BaseViewController {
  
  // MARK: - Constants
  
  static let identifier = R.storyboard.folder.addFolderStoryboard.identifier
  
  struct Metric {
    static let confirmButtonCornerRadius = 12.f
    
    static let emojiTextFieldFrameViewCornerRadius = 20.f
    
    static let folderTitleTextFieldLeftPadding = 8.f
    
    static let confirmButtonActiveAlpha = 1.f
    static let confirmButtonInactiveAlpha = 0.2.f
  }
  
  
  // MARK: - Types
  
  typealias ViewModel = AddFolderViewModel
  
  
  // MARK: - Properties
  
  weak var delegate: AddFolderViewDelegate?
  private let viewModel: ViewModel
  
  
  // MARK: - UI
  
  @IBOutlet weak var exitButton: UIButton!
  @IBOutlet weak var confirmButton: UIButton!
  @IBOutlet weak var emojiTextFieldFrameView: UIView!
  @IBOutlet weak var folderEmojiTextField: EmojiTextField!
  @IBOutlet weak var folderTitleTextField: HighlightingTextfield!
  
  
  // MARK: - Lifecycle
  
  init(_ viewModel: ViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  init?(_ coder: NSCoder, _ viewModel: ViewModel) {
    self.viewModel = viewModel
    super.init(coder: coder)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    bind()
  }
  
  
  // MARK: - Overrides
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    view.endEditing(true)
  }
  
  
  // MARK: - Setups
  
  private func setupView() {
    setupFolderTitleTextfield()
    setupConfirmButton()
    setupExitButton()
    setupEmojiTextFieldFrameView()
    setupFolderTitleTextField()
  }
  
  private func setupFolderTitleTextfield() {
    folderTitleTextField.delegate = self
    folderTitleTextField.returnKeyType = .done
  }
  
  private func setupConfirmButton() {
    confirmButton.layer.cornerRadius = Metric.confirmButtonCornerRadius
  }
  
  private func setupExitButton() {
    exitButton.makeAsCircle()
    exitButton.setReversedExitButtonShadow()
  }
  
  private func setupEmojiTextFieldFrameView() {
    emojiTextFieldFrameView.layer.cornerRadius = Metric.emojiTextFieldFrameViewCornerRadius
  }
  
  private func setupFolderTitleTextField() {
    folderTitleTextField.setLeftPadding(width: Metric.folderTitleTextFieldLeftPadding)
    folderTitleTextField.setPlaceholderColor(R.color.textTertiary()!)
    folderTitleTextField.becomeFirstResponder()
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
    
    folderEmojiTextField
      .rx.text
      .orEmpty
      .bind(to: viewModel.input.folderEmoji)
      .disposed(by: disposeBag)
    
    folderTitleTextField
      .rx.text
      .orEmpty
      .bind(to: viewModel.input.folderTitle)
      .disposed(by: disposeBag)
    
    confirmButton
      .rx.tap
      .bind(to: viewModel.input.tapConfirmButton)
      .disposed(by: disposeBag)
  }
  
  private func bindOutputs() {
    viewModel.output.dismiss
      .asDriver(onErrorDriveWith: .never())
      .drive(onNext: { [weak self] in
        self?.dismiss(animated: true)
      })
      .disposed(by: disposeBag)
    
    viewModel.output.isConfirmButtonActive
      .asDriver(onErrorDriveWith: .never())
      .drive(with: self, onNext: { vc, isActive in
        if isActive {
          vc.activeConfirmButton()
        } else {
          vc.inactiveConfirmButton()
        }
      })
      .disposed(by: disposeBag)
    
    viewModel.output.didFolderAdded
      .asDriver(onErrorDriveWith: .never())
      .drive(onNext: { [weak self] in
        self?.delegate?.didFolderAdded()
      })
      .disposed(by: disposeBag)
  }
  
  
  // MARK: - Method
  
  private func activeConfirmButton() {
    confirmButton.alpha = Metric.confirmButtonActiveAlpha
    confirmButton.isEnabled = true
  }
  
  private func inactiveConfirmButton() {
    confirmButton.alpha = Metric.confirmButtonInactiveAlpha
    confirmButton.isEnabled = false
  }
}


// MARK: - UITextFieldDelegate

extension AddFolderViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    view.endEditing(true)
    return false
  }
}
