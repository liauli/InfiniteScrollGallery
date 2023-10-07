//
//  MockApiService.swift
//  InfiniteScrollGalleryTests
//
//  Created by Aulia Nastiti on 06/10/23.
//

import Combine
import Foundation

@testable import InfiniteScrollGallery

class MockAPIService: APIService {
  var whenFetchGalleryItems: AnyPublisher<GalleryResponse, Error>!

  func fetchGalleryItems(_ page: Int) -> AnyPublisher<GalleryResponse, Error> {
    return whenFetchGalleryItems
  }
}
