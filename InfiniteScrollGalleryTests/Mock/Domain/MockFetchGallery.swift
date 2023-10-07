//
//  MockFetchGallery.swift
//  InfiniteScrollGalleryTests
//
//  Created by Aulia Nastiti on 06/10/23.
//

import Combine
import Foundation

@testable import InfiniteScrollGallery

class MockFetchGallery: FetchGallery {
  var whenExecute: AnyPublisher<GalleryResponse, Error>!

  func execute(_ page: Int) -> AnyPublisher<GalleryResponse, Error> {
    return whenExecute
  }
}
