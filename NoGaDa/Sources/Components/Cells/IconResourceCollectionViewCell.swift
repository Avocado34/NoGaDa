//
//  IconResourceCollectionViewCell.swift
//  NoGaDa
//
//  Created by 이승기 on 2021/09/29.
//

import UIKit


final class IconResourceCollectionViewCell: UICollectionViewCell {
  
  // MARK: - Constants
  
  static let identifier = R.reuseIdentifier.iconResourceCollectionCell.identifier
  
  struct Metric {
    static let cellContentViewCornerRadius = 12.f
  }
  
  
  // MARK: - UI
  
  @IBOutlet weak var cellContentView: UIView!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var iconImageView: UIImageView!
  
  
  // MARK: - Lifecycle
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupView()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    descriptionLabel.text = ""
    iconImageView.image = nil
  }
  
  
  // MARK: - Setups
  
  private func setupView() {
    setupCellContentView()
  }
  
  private func setupCellContentView() {
    cellContentView.layer.cornerRadius = Metric.cellContentViewCornerRadius
  }
}
