//
//  ChartTableViewCell.swift
//  NoGaDa
//
//  Created by 이승기 on 2021/09/18.
//

import UIKit


final class UpdatedSongTableViewCell: UITableViewCell {
  
  // MARK: - Constants
  
  static let identifier = R.reuseIdentifier.updatedSongTableViewCell.identifier
  
  struct Metric {
    static let thumbnailImageViewCornerRadius = 12.f
    
    static let selectedViewCornerRadius = 12.f
  }
  
  
  // MARK: - UI
  
  @IBOutlet weak var thumbnailImageView: UIImageView!
  @IBOutlet weak var thumbnailPlaceholderImageView: UIImageView!
  @IBOutlet weak var songTitleLabel: UILabel!
  @IBOutlet weak var singerLabel: UILabel!
  @IBOutlet weak var songNumberLabel: UILabel!
  
  
  // MARK: - Lifecycle
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setup()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    songTitleLabel.text = ""
    singerLabel.text = ""
    songNumberLabel.text = ""
  }
  
  
  // MARK: - Initializers
  
  private func setup() {
    setupView()
  }
  
  private func setupView() {
    setupThumbnailImageView()
    setupSelectedView()
  }
  
  private func setupThumbnailImageView() {
    thumbnailImageView.layer.cornerRadius = Metric.thumbnailImageViewCornerRadius
  }
  
  private func setupSelectedView() {
    let selectedView = UIView()
    selectedView.backgroundColor = R.color.backgroundBasicSelected()!
    selectedView.layer.cornerRadius = Metric.selectedViewCornerRadius
    selectedBackgroundView = selectedView
  }
  
  
  // MARK: - Methods
  
  public func configure(_ item: Song) {
    songTitleLabel.text = item.title
    songNumberLabel.text = item.no
    singerLabel.text = item.singer
  }
}
