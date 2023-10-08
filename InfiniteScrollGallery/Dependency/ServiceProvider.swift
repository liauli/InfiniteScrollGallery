//
//  ServiceProvider.swift
//  InfiniteScrollGallery
//
//  Created by Aulia Nastiti on 06/10/23.
//

import Foundation

class ServiceProvider {
  static let instance = ServiceProvider()

  func provideAPIService() -> APIServiceImpl {
    return APIServiceImpl(.shared)
  }
}
