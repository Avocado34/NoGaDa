//
//  KaraokeBrandPickerTableViewCell.swift
//  NoGaDa
//
//  Created by 이승기 on 2022/01/06.
//

import UIKit


final class KaraokeBrandPickerTableViewCell: UITableViewCell {
  
  // MARK: - Constants
  
  static let identifier = R.reuseIdentifier.karaokeBrandTableCell.identifier
  
  
  // MARK: - UI
  
  @IBOutlet weak var brandNameLabel: UILabel!
  
  
  // MARK: - Lifecycle
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupView()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    brandNameLabel.text = ""
  }
  
  
  // MARK: - Setups
  
  private func setupView() {
    setupSelectedView()
  }
  
  private func setupSelectedView() {
    let selectedView = UIView()
    selectedView.bounds = bounds
    selectedView.backgroundColor = R.color.accentYellowDark()
    selectedBackgroundView = selectedView
  }
}
