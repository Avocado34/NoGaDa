//
//  SettingEtcTableViewCell.swift
//  NoGaDa
//
//  Created by 이승기 on 2021/09/29.
//

import UIKit

import RxSwift
import RxCocoa

class SettingItemTableViewCell: UITableViewCell {
  
  // MARK: - Constants
  
  static let identifier = R.reuseIdentifier.settingEtcTableCell.identifier
  
  struct Metric {
    static let iconContainerViewCornerRadius = 12.f
    
    static let selectedViewCornerRadius = 12.f
  }
  
  
  // MARK: - Properties
  
  private var disposeBag = DisposeBag()
  var itemSelectAction: () -> Void = {}
  
  
  // MARK: - UI
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var iconImageView: UIImageView!
  
  
  // MARK: - Lifecycle
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupView()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    titleLabel.text = ""
    iconImageView.image = nil
    itemSelectAction = {}
  }
  
  
  // MARK: - Setups
  
  private func setupView() {
    setupSelectedView()
    setupAction()
  }
  
  private func setupSelectedView() {
    let selectedView = UIView()
    selectedView.bounds = bounds
    selectedView.backgroundColor = R.color.backgroundBasicSelected()!
    selectedView.layer.cornerRadius = Metric.selectedViewCornerRadius
    selectedBackgroundView = selectedView
  }

  private func setupAction() {
    self.rx.tapGesture()
      .when(.recognized)
      .asDriver(onErrorDriveWith: .never())
      .drive(with: self, onNext: { strongSelf, _ in
        strongSelf.itemSelectAction()
      }).disposed(by: disposeBag)
  }
  
  
  // MARK: - Methods
  
  func configure(item: SettingItem) {
    titleLabel.text = item.title
    iconImageView.image = item.icon
    iconImageView.tintColor = item.iconContainerColor
  }
}
