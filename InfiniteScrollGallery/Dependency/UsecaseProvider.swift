//
//  UsecaseProvider.swift
//  InfiniteScrollGallery
//
//  Created by Aulia Nastiti on 08/10/23.
//

import Foundation

class UsecaseProvider {
  private let repositoryProvider = RepositoryProvider.instance
  static let instance = UsecaseProvider()

  func provideFetchGallery() -> FetchGalleryImpl {
    let galleryRepository = repositoryProvider.provideGalleryRepository()

    return FetchGalleryImpl(galleryRepository)
  }
  
  func provideSearchGallery() -> SearchGalleryImpl {
    let galleryRepository = repositoryProvider.provideGalleryRepository()

    return SearchGalleryImpl(galleryRepository)
  }
}
