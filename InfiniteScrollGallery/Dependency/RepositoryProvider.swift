//
//  RepositoryProvider.swift
//  InfiniteScrollGallery
//
//  Created by Aulia Nastiti on 08/10/23.
//

import Foundation

class RepositoryProvider {
  private let serviceProvider = ServiceProvider.instance

  static let instance = RepositoryProvider()

  func provideGalleryRepository() -> GalleryRepositoryImpl {
    let apiService = serviceProvider.provideAPIService()
    
    return GalleryRepositoryImpl(apiService)
  }
}
