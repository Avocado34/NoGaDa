//
//  SearchHistoryTableViewCell.swift
//  NoGaDa
//
//  Created by 이승기 on 2021/10/10.
//

import UIKit
import RxSwift
import RxCocoa

class SearchHistoryTableViewCell: UITableViewCell {
  
  // MARK: - Constants
  
  static let identifier = R.reuseIdentifier.searchHistoryTableCell.identifier
  
  struct Metric {
    static let tapReleaseAnimationDuration = 0.2.f
  }
  
  
  // MARK: - Properties
  
  private var disposeBag = DisposeBag()
  public var removeButtonTapAction: () -> Void = {}
  
  
  // MARK: - UI
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var removeButton: UIButton!
  
  
  // MARK: - Lifecycle
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setup()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    titleLabel.text = ""
    selectionStyle = .none
  }
  
  
  // MARK: - Setups
  
  private func setup() {
    setupSelectedView()
    bind()
  }
  
  private func setupSelectedView() {
    let selectedView = UIView()
    selectedView.backgroundColor = R.color.backgroundBasicSelected()
    selectedBackgroundView = selectedView
  }
  
  
  // MARK: - Binds
  
  private func bind() {
    removeButton.rx.tap
      .bind(onNext: { [weak self] in
        self?.removeButtonTapAction()
      }).disposed(by: disposeBag)
  }
}
