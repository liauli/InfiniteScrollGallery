//
//  GalleryAction.swift
//  InfiniteScrollGallery
//
//  Created by Aulia Nastiti on 08/10/23.
//

import Foundation

enum GalleryAction: Equatable {
  case showLoading
  case hideLoading
  case resetGallery
  case startSearchMode
  case resetSearchMode
  case addItems(_ response: GalleryResponse, _ query: String? = nil)
  case showError
}
