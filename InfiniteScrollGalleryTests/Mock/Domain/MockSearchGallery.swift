//
//  MockSearchGallery.swift
//  InfiniteScrollGalleryTests
//
//  Created by Aulia Nastiti on 08/10/23.
//

import Combine
import Foundation

@testable import InfiniteScrollGallery

class MockSearchGallery: SearchGallery {
  var whenExecute: AnyPublisher<GalleryResponse, Error>!

  func execute(_ query: String, _ page: Int) -> AnyPublisher<GalleryResponse, Error> {
    return whenExecute
  }
}
