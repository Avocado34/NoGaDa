//
//  SplashViewController.swift
//  NoGaDa
//
//  Created by 이승기 on 2022/08/30.
//

import UIKit

import RxSwift


final class SplashViewController: UIViewController {
  
  // MARK: - UI
  
  private var splashImageView: UIImageView = {
    var imageView = UIImageView()
    imageView.image = R.image.splashImage()!
    return imageView
  }()
  
  
  // MARK: - Properties
  
  private var disposeBag = DisposeBag()
  private var didUpdateConstraints = false
  
  
  // MARK: - LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    presentMainViewController()
  }
  
  
  // MARK: - Setups
  
  private func setup() {
    setupView()
  }
  
  private func setupView() {
    setupBaseView()
    setupSplashImageView()
  }
  
  private func setupBaseView() {
    self.view.backgroundColor = R.color.accentYellow()!
  }
  
  private func setupSplashImageView() {
    self.view.addSubview(splashImageView)
    splashImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      splashImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      splashImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -36),
      splashImageView.widthAnchor.constraint(equalToConstant: 200),
      splashImageView.heightAnchor.constraint(equalToConstant: 200)
    ])
  }
  
  
  // MARK: - Methods
  
  private func presentMainViewController() {
    let storyboard = UIStoryboard(name: R.storyboard.main.name, bundle: nil)
    let viewController = storyboard.instantiateViewController(identifier: MainViewController.identifier,
                                                              creator: { coder -> MainViewController in
      let viewModel = MainViewModel()
      return .init(coder, viewModel) ?? MainViewController(viewModel)
    })
    
    self.view.window?.rootViewController = viewController
    self.view.window?.makeKeyAndVisible()
  }
}
