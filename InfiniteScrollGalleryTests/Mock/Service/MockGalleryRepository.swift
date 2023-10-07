//
//  MockGalleryRepository.swift
//  InfiniteScrollGalleryTests
//
//  Created by Aulia Nastiti on 06/10/23.
//

import Combine
import Foundation

@testable import InfiniteScrollGallery

class MockGalleryRepository: GalleryRepository {
  var whenFetchGalleryItems: AnyPublisher<GalleryResponse, Error>!

  var fetchGalleryItemsCount = 0

  func fetchGalleryItems(_ page: Int) -> AnyPublisher<GalleryResponse, Error> {
    fetchGalleryItemsCount += 1

    return whenFetchGalleryItems
  }
}
