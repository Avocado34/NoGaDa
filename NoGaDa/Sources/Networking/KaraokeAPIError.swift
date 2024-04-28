//
//  KaraokeAPIError.swift
//  NoGaDa
//
//  Created by 이승기 on 2021/09/23.
//

import UIKit


enum KaraokeAPIError: Error {
  case urlParsingError
  case didNotReceiveData
  case httpRequestFailure
  case jsonParsingError
  
  public var message: String {
    switch self {
    case .urlParsingError:
      return "Error: fail to parsing url string"
    
    case .didNotReceiveData:
      return "Error: did not receive data"
    
    case .httpRequestFailure:
      return "Error: HTTP request failed"
    
    case .jsonParsingError:
      return "Error: JSON Data Parsing failed"
    }
  }
}
