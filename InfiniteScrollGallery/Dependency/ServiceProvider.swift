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

class RepositoryProvider {
  private let serviceProvider = ServiceProvider.instance

  static let instance = RepositoryProvider()

  func provideGalleryRepository() -> GalleryRepositoryImpl {
    let apiService = serviceProvider.provideAPIService()
    
    return GalleryRepositoryImpl(apiService)
  }
}

class UsecaseProvider {
  private let repositoryProvider = RepositoryProvider.instance
  static let instance = UsecaseProvider()

  func provideFetchGallery() -> FetchGalleryImpl {
    let currencyRepository = repositoryProvider.provideGalleryRepository()

    return FetchGalleryImpl(currencyRepository)
  }
}


class ViewModelProvider {
  private let usecaseProvider = UsecaseProvider.instance
  static let instance = ViewModelProvider()

  func provideGalleryViewModel() -> GalleryViewModel {
    let fetchGallery = usecaseProvider.provideFetchGallery()

    return GalleryViewModel(fetchGallery)
  }
}


