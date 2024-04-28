//
//  CreditViewController.swift
//  NoGaDa
//
//  Created by 이승기 on 2021/09/29.
//

import UIKit

import RxSwift
import RxCocoa
import RxGesture

import MessageUI


final class CreditViewController: BaseViewController, ViewModelInjectable {
  
  // MARK: - Constants
  
  static let identifier = R.storyboard.setting.creditStoryboard.identifier
  
  struct Metric {
    static let resourceCollectionViewLeftInset = 28.f
    static let resourceCollectionViewRightInset = 28.f
  }
  
  
  // MARK: - Types
  
  typealias ViewModel = CreditViewModel
  
  // MARK: - Properties
  
  var viewModel: ViewModel
  
  
  // MARK: - UI
  
  @IBOutlet weak var exitButton: UIButton!
  @IBOutlet weak var headerLabel: UILabel!
  @IBOutlet weak var contentScrollView: UIScrollView!
  @IBOutlet weak var resourceCollectionView: UICollectionView!
  @IBOutlet weak var contactTextView: UITextView!
  
  
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
    setupHeaderLabel()
    setupIconResourceCollectionView()
  }
  
  private func setupHeaderLabel() {
    headerLabel.text = "노가다\n노래방 가서 다 부를거야\n\nVersion \(viewModel.appVersion)"
  }
  
  private func setupIconResourceCollectionView() {
    registerIconResourceCollectionCell()
    resourceCollectionView.contentInset = UIEdgeInsets(top: 0, left: Metric.resourceCollectionViewLeftInset, bottom: 0, right: Metric.resourceCollectionViewRightInset)
  }
  
  private func registerIconResourceCollectionCell() {
    let nibName = UINib(nibName: R.nib.iconResourceCollectionViewCell.name, bundle: nil)
    resourceCollectionView.register(nibName, forCellWithReuseIdentifier: IconResourceCollectionViewCell.identifier)
  }
  
  
  // MARK: Binding
  
  private func bind() {
    bindInputs()
    bindOutputs()
  }
  
  private func bindInputs() {
    exitButton
      .rx.tap
      .bind(to: viewModel.input.tapExitButton)
      .disposed(by: disposeBag)
  }
  
  private func bindOutputs() {
    viewModel.output.dismiss
      .asDriver(onErrorDriveWith: .never())
      .drive(onNext: { [weak self] in
        self?.dismiss(animated: true)
      })
      .disposed(by: disposeBag)
    
    viewModel.output.showingMailComposeVC
      .asDriver(onErrorDriveWith: .never())
      .drive(with: self, onNext: { vc, mailInfo  in
        if MFMailComposeViewController.canSendMail() {
          let composeVC = MFMailComposeViewController()
          composeVC.setToRecipients(mailInfo.recipients)
          composeVC.setSubject(mailInfo.subject)
          composeVC.setMessageBody("", isHTML: false)
          vc.present(composeVC, animated: true, completion: nil)
        } else {
          print("Can't send an email for some reason")
        }
      })
      .disposed(by: disposeBag)
    
    viewModel.output.iconResources
      .bind(to: resourceCollectionView.rx.items(cellIdentifier: IconResourceCollectionViewCell.identifier, cellType: IconResourceCollectionViewCell.self)) { [weak self] index, item, cell in
        guard let self = self else { return }
        cell.descriptionLabel.text = item.description
        cell.iconImageView.image = item.image
        cell.rx.tapGesture()
          .when(.recognized)
          .bind(with: self, onNext: { vc, _ in
            item.openLink(vc: vc)
          }).disposed(by: self.disposeBag)
      }
      .disposed(by: disposeBag)
  }
}
