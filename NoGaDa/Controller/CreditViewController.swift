//
//  CreditViewController.swift
//  NoGaDa
//
//  Created by 이승기 on 2021/09/29.
//

import UIKit

import RxSwift
import RxCocoa
import RxGesture
import MessageUI

class CreditViewController: UIViewController {

    // MARK: - Declaration
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var contactUsBoxView: UIView!
    @IBOutlet weak var catactUsIconBoxView: UIView!
    @IBOutlet weak var iconResourceCollectionView: UICollectionView!
    @IBOutlet weak var contactTextView: UITextView!
    
    private var disposeBag = DisposeBag()
    private var creditViewModel = CreditViewModel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        bind()
    }
    
    // MARK: - Initializers
    private func setupView() {
        setupHeaderLabel()
        setupContactUsBoxView()
        setupIconResourceCollectionView()
        setupContactTextView()
    }
    
    private func bind() {
        bindExitButton()
        bindContactUsBoxView()
    }
    
    // MARK: - Setups
    private func setupHeaderLabel() {
        headerLabel.text = creditViewModel.headerText
    }
    
    private func setupContactUsBoxView() {
        contactUsBoxView.layer.cornerRadius = 20
        contactUsBoxView.makeAsSettingGroupView()
        catactUsIconBoxView.layer.cornerRadius = 12
    }
    
    private func setupIconResourceCollectionView() {
        iconResourceCollectionView.contentInset = UIEdgeInsets(top: 0, left: 28, bottom: 0, right: 28)
        
        let nibName = UINib(nibName: "IconResourceCollectionViewCell", bundle: nil)
        iconResourceCollectionView.register(nibName, forCellWithReuseIdentifier: "iconResourceCollectionCell")
        iconResourceCollectionView.dataSource = self
        iconResourceCollectionView.delegate = self
    }
    
    private func setupContactTextView() {
        contactTextView.dataDetectorTypes = .all
    }
    
    // MARK: Binds
    private func bindExitButton() {
        exitButton.rx.tap
            .asDriver()
            .drive(with: self, onNext: { vc, _ in
                vc.dismiss(animated: true, completion: nil)
            }).disposed(by: disposeBag)
    }
    
    private func bindContactUsBoxView() {
        contactUsBoxView.rx.tapGesture()
            .when(.recognized)
            .bind(with: self, onNext: { vc, _ in
                if MFMailComposeViewController.canSendMail() {
                    let composeVC = MFMailComposeViewController()
                    
                    composeVC.setToRecipients(vc.creditViewModel.emailRecipients)
                    composeVC.setSubject(vc.creditViewModel.sendEmailErrorMessage)
                    composeVC.setMessageBody("", isHTML: false)
                    
                    vc.present(composeVC, animated: true, completion: nil)
                } else {
                    print(vc.creditViewModel.sendEmailErrorMessage)
                }
            }).disposed(by: disposeBag)
    }
    
    // MARK: - Methods
}

// MARK: Extensions
extension CreditViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return creditViewModel.numberOfRowInSection(creditViewModel.sectionCount)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let resourceCell = collectionView.dequeueReusableCell(withReuseIdentifier: "iconResourceCollectionCell", for: indexPath) as? IconResourceCollectionViewCell else { return UICollectionViewCell() }
        
        let resourceItem = creditViewModel.resourceItemAtIndex(indexPath)
        resourceCell.descriptionLabel.text  = resourceItem.description
        resourceCell.iconImageView.image    = resourceItem.image
        
        resourceCell.rx.tapGesture()
            .when(.recognized)
            .bind(with: self, onNext: { vc, _ in
                resourceItem.openLink(vc: vc)
            }).disposed(by: disposeBag)
        
        return resourceCell
    }
}
