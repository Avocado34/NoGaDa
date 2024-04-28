//
//  SceneDelegate.swift
//  NoGaDa
//
//  Created by 이승기 on 2021/09/17.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    window = UIWindow(windowScene: windowScene)
    window?.rootViewController = splashViewController
    window?.makeKeyAndVisible()
    
    countUpAppLaunchCount()
  }
}

extension SceneDelegate {
  private var splashViewController: UIViewController {
    let viewController = SplashViewController()
    return viewController
  }
  
  private func countUpAppLaunchCount() {
    let value = UserDefaults.standard.integer(forKey: DefaultsKey.launchCount.name)
    UserDefaults.standard.set(value + 1, forKey: DefaultsKey.launchCount.name)
  }
}
