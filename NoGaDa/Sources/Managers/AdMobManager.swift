//
//  AdMobManager.swift
//  NoGaDa
//
//  Created by 이승기 on 2021/10/07.
//

import UIKit

import GoogleMobileAds
import RxSwift
import RxCocoa


enum AdMobUnitID {
  static let testInterstitial = "ca-app-pub-3940256099942544/4411468910"
  static let initialAd = "ca-app-pub-3998172297943713/4233053278"
}

final class AdMobManager {
  
  
  // MARK: - Properties
  
  static let shared = AdMobManager()
  private var interstitial: GADInterstitialAd?
  public var presentFrequency = 1
  
  
  // MARK: - Initializers
  
  private init() { }
  
  
  // MARK: - Methods
  
  public func presentInitialAd(vc: UIViewController) {
    // Skip ad for first time users
    let value = UserDefaults.standard.integer(forKey: DefaultsKey.launchCount.name)
    if value == 1 {
      return
    }
    
    let request = GADRequest()
    GADInterstitialAd.load(withAdUnitID: AdMobUnitID.initialAd,
                           request: request) { ad, error in
      if let error = error {
        print(error.localizedDescription)
      } else {
        ad?.present(fromRootViewController: vc)
      }
    }
  }
  
  public func testPresentAd(vc: UIViewController) {
    self.interstitial?.present(fromRootViewController: vc)
  }
}


// MARK: - AdMob frequency

extension AdMobManager {
  private func adMobUsageState() -> Bool {
    let currentUsageCount = UserDefaults.standard.integer(forKey: "admobUsageCount")
    
    if currentUsageCount % presentFrequency == 0 {
      return true
    } else {
      return false
    }
  }
  
  private func updateAdMobUsageCount() {
    let currentUsageState = UserDefaults.standard.integer(forKey: "admobUsageCount")
    UserDefaults.standard.set(currentUsageState + 1, forKey: "admobUsageCount")
  }
}
