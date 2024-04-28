//
//  SearchFilterTableViewCell.swift
//  NoGaDa
//
//  Created by 이승기 on 2021/09/21.
//

import UIKit

import RxSwift


final class SearchFilterTableViewCell: UITableViewCell {
  
  // MARK: - Constants
  
  static let identifier = R.reuseIdentifier.searchFilterTableCell.identifier
  
  
  // MARK: - Properties
  
  private var disposeBag = DisposeBag()
  private var item: (any SearchFilterItem)?
  
  
  // MARK: - UI
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var filterSwitch: UISwitch!
  
  
  // MARK: - Lifecycle
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupView()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    titleLabel.text = item?.title
    filterSwitch.isOn = item?.state ?? true
  }
  
  
  // MARK: - Setups
  
  private func setupView() {
    selectionStyle = .none
  }
  
  
  // MARK: - Methods
  
  public func configure(_ item: SearchFilterItem) {
    titleLabel.text = item.title
    filterSwitch.isOn = item.state
    filterSwitch.rx.controlEvent(.valueChanged)
      .subscribe(onNext: { _ in
        item.toggleState()
      }).disposed(by: self.disposeBag)
  }
}
