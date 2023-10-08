//
//  SearchGalleryTest.swift
//  InfiniteScrollGalleryTests
//
//  Created by Aulia Nastiti on 08/10/23.
//

import Combine
import Foundation
import XCTest

@testable import InfiniteScrollGallery

class SearchGalleryTest: XCTestCase {
  private var mockGalleryRepository: MockGalleryRepository!
  private var sut: SearchGallery!

  override func setUp() {
    mockGalleryRepository = MockGalleryRepository()

    sut = SearchGalleryImpl(mockGalleryRepository)
  }

  override func tearDown() {
    mockGalleryRepository = nil
    sut = nil
  }

  func testExecute_Success() {
    let expectedGalleryResponse = createGalleryResponse()
    
    mockGalleryRepository.whenSearchGallery = success(expectedGalleryResponse)

    let expectation = self.expectation(description: "execute success")
    var galleryResponse: GalleryResponse?
    var completionError: Error?

    let cancellable = sut.execute(randomString(2), 1)
      .sink { completion in
        if case let .failure(error) = completion {
          completionError = error
        }
        expectation.fulfill()
      } receiveValue: { response in
        galleryResponse = response
      }

    waitForExpectations(timeout: 1.0, handler: nil)
    cancellable.cancel()

    XCTAssertNil(completionError)
    XCTAssertEqual(expectedGalleryResponse, galleryResponse)
    XCTAssertEqual(mockGalleryRepository.searchGalleryItemsCount, 1)
  }

  func testExecute_failed() {
    let expectedError = ApiError.failToDecode

    mockGalleryRepository.whenSearchGallery = failed(expectedError)

    let expectation = self.expectation(
      description: "execute throw failed")
    var galleryResponse: GalleryResponse?
    var completionError: Error?

    let cancellable = sut.execute(randomString(2), 1)
      .sink { completion in
        if case let .failure(error) = completion {
          completionError = error
        }
        expectation.fulfill()
      } receiveValue: { response in
        galleryResponse = response
      }

    waitForExpectations(timeout: 1.0, handler: nil)
    cancellable.cancel()

    XCTAssertNil(galleryResponse)
    XCTAssertEqual(String(describing: expectedError), String(describing: completionError!))
    XCTAssertEqual(mockGalleryRepository.searchGalleryItemsCount, 1)
  }
}
