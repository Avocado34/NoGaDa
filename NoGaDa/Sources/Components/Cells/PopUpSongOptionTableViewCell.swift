//
//  SongOptionTableViewCell.swift
//  NoGaDa
//
//  Created by 이승기 on 2021/12/14.
//

import UIKit


final class PopUpSongOptionTableViewCell: UITableViewCell {
  
  // MARK: - Constants
  
  static let identifier = R.reuseIdentifier.popUpSongOptionTableCell.identifier
  
  
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
  }
  
  
  // MARK: - Setups
  
  private func setupView() {
    setupSelectedView()
  }
  
  private func setupSelectedView() {
    let selectionView = UIView(frame: self.bounds)
    selectionView.backgroundColor = R.color.backgroundBasicSelected()!
    selectedBackgroundView = selectionView
  }
  
  
  // MARK: - Methods
  
  public func configure(_ item: SongOption) {
    titleLabel.text = item.title
    iconImageView.image = item.icon
  }
}
