//
//  FetchGalleryTest.swift
//  InfiniteScrollGalleryTests
//
//  Created by Aulia Nastiti on 06/10/23.
//

import Combine
import Foundation
import XCTest

@testable import InfiniteScrollGallery

class FetchGalleryTest: XCTestCase {
  private var mockGalleryRepository: MockGalleryRepository!
  private var sut: FetchGallery!

  override func setUp() {
    mockGalleryRepository = MockGalleryRepository()

    sut = FetchGalleryImpl(mockGalleryRepository)
  }

  override func tearDown() {
    mockGalleryRepository = nil
    sut = nil
  }

  func testExecute_Success() {
    let expectedGalleryResponse = createGalleryResponse()
    
    mockGalleryRepository.whenFetchGalleryItems = success(expectedGalleryResponse)

    let expectation = self.expectation(description: "execute success")
    var galleryResponse: GalleryResponse?
    var completionError: Error?

    let cancellable = sut.execute(1)
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
    XCTAssertEqual(mockGalleryRepository.fetchGalleryItemsCount, 1)
  }

  func testExecute_failed() {
    let expectedError = ApiError.failToDecode

    mockGalleryRepository.whenFetchGalleryItems = failed(expectedError)

    let expectation = self.expectation(
      description: "execute throw failed")
    var galleryResponse: GalleryResponse?
    var completionError: Error?

    let cancellable = sut.execute(1)
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
    XCTAssertEqual(mockGalleryRepository.fetchGalleryItemsCount, 1)
  }
}
