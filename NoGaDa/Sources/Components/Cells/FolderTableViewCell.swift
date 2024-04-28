//
//  FolderTableViewCell.swift
//  NoGaDa
//
//  Created by 이승기 on 2021/09/17.
//

import UIKit


final class FolderTableViewCell: UITableViewCell {
  
  // MARK: - Constants
  
  static let identifier = R.reuseIdentifier.folderTableViewCell.identifier
  
  struct Metric {
    static let tapAnimationDuration = 0.2.f
    static let tapReleaseAnimationDuration = 0.15.f
    
    static let cellContentViewCornerRadius = 12.f
    static let cellContentViewBorderWidth = 1.f
  }
  
  
  // MARK: - UI
  
  @IBOutlet weak var cellContentView: UIView!
  @IBOutlet weak var titleEmojiLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  
  
  // MARK: - Lifecycle
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupView()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    cellContentView.layer.borderColor = R.color.lineBasic()!.cgColor
    titleEmojiLabel.text = ""
    titleLabel.text = ""
  }
  
  
  // MARK: - Setups
  
  private func setupView() {
    cellContentView.layer.borderWidth = Metric.cellContentViewBorderWidth
    cellContentView.layer.borderColor = R.color.lineBasic()!.cgColor
    cellContentView.layer.cornerRadius = Metric.cellContentViewCornerRadius
  }
  
  
  // MARK: - Methods
  
  public func configure(_ item: ArchiveFolder) {
    titleEmojiLabel.text = item.titleEmoji
    titleLabel.text = item.title
  }
}


// MARK: - Touch Animation

extension FolderTableViewCell {
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    UIView.animate(withDuration: Metric.tapAnimationDuration, delay: 0, options: .curveEaseInOut) {
      self.cellContentView.backgroundColor = R.color.backgroundBasicSelected()
      self.cellContentView.scaleDown()
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    UIView.animate(withDuration: Metric.tapReleaseAnimationDuration, delay: 0, options: .curveEaseInOut) {
      self.cellContentView.backgroundColor = R.color.backgroundSecondary()
      self.cellContentView.releaseScale()
    }
  }
  
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesCancelled(touches, with: event)
    UIView.animate(withDuration: Metric.tapReleaseAnimationDuration, delay: 0, options: .curveEaseInOut) {
      self.cellContentView.backgroundColor = R.color.backgroundSecondary()
      self.cellContentView.releaseScale()
    }
  }
}
