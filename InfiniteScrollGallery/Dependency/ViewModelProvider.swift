//
//  ViewModelProvider.swift
//  InfiniteScrollGallery
//
//  Created by Aulia Nastiti on 08/10/23.
//

import Foundation

class ViewModelProvider {
  private let usecaseProvider = UsecaseProvider.instance
  static let instance = ViewModelProvider()

  func provideGalleryViewModel() -> GalleryViewModel {
    let fetchGallery = usecaseProvider.provideFetchGallery()
    let searchGallery = usecaseProvider.provideSearchGallery()

    return GalleryViewModel(fetchGallery, searchGallery)
  }
}
