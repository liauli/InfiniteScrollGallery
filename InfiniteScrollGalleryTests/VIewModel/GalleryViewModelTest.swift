//
//  GalleryViewModelTest.swift
//  InfiniteScrollGalleryTests
//
//  Created by Aulia Nastiti on 06/10/23.
//

import Combine
import Foundation
import XCTest

@testable import InfiniteScrollGallery

class CurrencyViewModelTest: XCTestCase {
  private var mockFetchGallery: MockFetchGallery!
  private var cancellables: Set<AnyCancellable> = []
  private var sut: GalleryViewModel!

  override func setUp() {
    mockFetchGallery = MockFetchGallery()

    sut = GalleryViewModel(mockFetchGallery)
  }

  override func tearDown() {
    mockFetchGallery = nil
    sut = nil
    cancellables.removeAll()
  }

  func testInitialLoad_Success() {
    let expectedData = createGalleryResponse()

    let expectedViewState = GalleryViewState(
      isLoading: false,
      gallery: expectedData.data,
      currentPage: expectedData.pagination.currentPage,
      imageUrl: expectedData.config.iiifUrl
    )

    mockFetchGallery.whenExecute = success(expectedData)

    sut.initialLoad()

    let expectation = self.expectation(description: "Initial Load Completed")
    var receivedValues: [GalleryViewState] = []

    sut.$viewState.sink { viewState in
      receivedValues.append(viewState)

      if receivedValues.count == 2 {
        expectation.fulfill()
      }
    }.store(in: &cancellables)

    waitForExpectations(timeout: 5.0, handler: nil)
    XCTAssertEqual(expectedViewState, receivedValues.last)
  }
  
  //TODO: ADD ERROR HANDLING
  func testInitialLoad_Failed() {
    let errorMessage = "Failed to load currency with error"
    let expectedError = ApiError.wrongPath

//    mockLoadCurrency.whenExecute = failed(expectedError)
//
//    sut.initialLoad()
//
//    let expectation = self.expectation(description: "Initial Load Failed")
//    var receivedValues: [CurrencyViewState] = []
//
//    sut.$viewState.sink { viewState in
//      receivedValues.append(viewState)
//
//      if receivedValues.count == 2 {  //initial value and updated value
//        expectation.fulfill()
//      }
//    }.store(in: &cancellables)
//
//    waitForExpectations(timeout: 5.0, handler: nil)
//    XCTAssertEqual(expectedViewState, receivedValues.last)
  }
}

