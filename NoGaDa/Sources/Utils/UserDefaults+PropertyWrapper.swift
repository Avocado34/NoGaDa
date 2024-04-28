//
//  UserDefaults+PropertyWrapper.swift
//  NoGaDa
//
//  Created by 이승기 on 2023/03/28.
//

import Foundation


// MARK: - General Value

@propertyWrapper
struct UserDefault<T> {
  
  private let key: String
  private let defaultValue: T
  
  init(key: String, defaultValue: T) {
    self.key = key
    self.defaultValue = defaultValue
  }
  
  public var wrappedValue: T {
    get { return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue }
    set { UserDefaults.standard.set(newValue, forKey: key) }
  }
}


// MARK: - Enum Value

@propertyWrapper
struct UserDefaultEnum<E: RawRepresentable> {
  
  private let key: String
  private let defaultValue: E
  
  init(key: String, defaultValue: E) {
    self.key = key
    self.defaultValue = defaultValue
  }
 
  var wrappedValue: E {
    get { return E(rawValue: UserDefaults.standard.object(forKey: key) as? E.RawValue ?? defaultValue.rawValue) ?? defaultValue }
    set { UserDefaults.standard.setValue(newValue.rawValue, forKey: key) }
  }
}
