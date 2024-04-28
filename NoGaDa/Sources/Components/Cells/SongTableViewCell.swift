//
//  SearchResultTableViewCell.swift
//  NoGaDa
//
//  Created by 이승기 on 2021/09/17.
//

import UIKit


final class SongTableViewCell: UITableViewCell {
  
  // MARK: - Constants
  
  static let identifier = R.reuseIdentifier.searchResultTableViewCell.identifier
  
  struct Metric {
    static let thumbnailImageViewCornerRadius = 16.f
    
    static let selectedViewCornerRadius = 20.f
  }
  
  
  // MARK: - UI
  
  @IBOutlet weak var thumbnailImageView: UIImageView!
  @IBOutlet weak var thumbnailPlaceholderImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var singerLabel: UILabel!
  @IBOutlet weak var songNumberLabel: UILabel!
  
  
  // MARK: - Lifecycle
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupView()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    titleLabel.releaseAccentColor(with: R.color.textBasic()!)
    singerLabel.releaseAccentColor(with: R.color.textSecondary()!)
    songNumberLabel.text = ""
    titleLabel.text = ""
    singerLabel.text = ""
  }
  
  
  // MARK: - Setups
  
  private func setupView() {
    setupThumbnailImageView()
    setupSelectedView()
  }
  
  private func setupThumbnailImageView() {
    thumbnailImageView.layer.cornerRadius = Metric.thumbnailImageViewCornerRadius
  }
  
  private func setupSelectedView() {
    let selectedView = UIView()
    selectedView.backgroundColor = R.color.backgroundBasicSelected()
    selectedView.layer.cornerRadius = Metric.selectedViewCornerRadius
    selectedBackgroundView = selectedView
  }
  
  
  // MARK: - Methods
  
  public func configure(_ item: Song, term: String = "") {
    titleLabel.text = item.title
    singerLabel.text = item.singer
    songNumberLabel.text = "\(item.brand.localizedString) \(item.no)"
    
    highlightSearchTerm(term: term)
  }
  
  public func highlightSearchTerm(term: String = "") {
    let searchWithTitle = UserDefaultsManager.searchWithTitle
    let searchWithSinger = UserDefaultsManager.searchWithSinger
    
    if searchWithTitle == true &&
        searchWithSinger == true {
      titleLabel.setAccentColor(string: term)
      singerLabel.setAccentColor(string: term)
    }
    else if searchWithTitle == false &&
              searchWithSinger == true {
      singerLabel.setAccentColor(string: term)
    }
    else if searchWithTitle == true &&
              searchWithSinger == false {
      titleLabel.setAccentColor(string: term)
    }
  }
}
