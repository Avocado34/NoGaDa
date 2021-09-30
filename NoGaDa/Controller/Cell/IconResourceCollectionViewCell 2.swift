//
//  IconResourceCollectionViewCell.swift
//  NoGaDa
//
//  Created by 이승기 on 2021/09/29.
//

import UIKit

class IconResourceCollectionViewCell: UICollectionViewCell {

    // MARK: - Declaration
    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initView()
    }

    // MARK: - Initialization
    private func initView() {
        cellContentView.layer.cornerRadius = 12
    }
}