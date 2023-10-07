//
//  GalleryRepositoryTest.swift
//  InfiniteScrollGalleryTests
//
//  Created by Aulia Nastiti on 06/10/23.
//

import Combine
import XCTest

@testable import InfiniteScrollGallery

class GalleryRepositoryTest: XCTestCase {
  var sut: GalleryRepository!
  var apiService: MockAPIService!
  var userDefaults: UserDefaults!

  override func setUp() {
    super.setUp()
    apiService = MockAPIService()

    sut = GalleryRepositoryImpl(apiService)
  }

  override func tearDown() {
    apiService = nil
    sut = nil
    super.tearDown()
  }

  func testFetchGalleryItems_Success() {
    let expectedResponse = createGalleryResponse()

    apiService.whenFetchGalleryItems = success(expectedResponse)
    
    let expectation = self.expectation(description: "Fetch gallery items")

    var completionError: Error?
    var responseResult: GalleryResponse?
    let cancellable = sut.fetchGalleryItems(1).sink(
      receiveCompletion: { completion in
        if case let .failure(error) = completion {
          completionError = error
        }
        expectation.fulfill()
      },
      receiveValue: { response in
          responseResult = response
      }
    )

    waitForExpectations(timeout: 1.0, handler: nil)
    cancellable.cancel()
    XCTAssertNil(completionError)
    XCTAssertEqual(expectedResponse, responseResult)
  }

  func testFetchGalleryItems_ApiFailure() {
    let expectedError = NSError(domain: randomString(2), code: 400)
    apiService.whenFetchGalleryItems = failed(expectedError)

    let expectation = self.expectation(description: "Fetch gallery items API failure")
    var completionError: Error?
    let cancellable = sut.fetchGalleryItems(1).sink(
      receiveCompletion: { completion in
        if case let .failure(error) = completion {
          completionError = error
        }
        expectation.fulfill()
      },
      receiveValue: { _ in }
    )

    waitForExpectations(timeout: 1.0, handler: nil)
    cancellable.cancel()

    XCTAssertEqual(String(describing: expectedError), String(describing: completionError!))
  }
}
