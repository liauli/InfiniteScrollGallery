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

class GalleryViewModelTest: XCTestCase {
  private var mockFetchGallery: MockFetchGallery!
  private var mockSearchGallery: MockSearchGallery!
  
  private var cancellables: Set<AnyCancellable> = []
  var sut: GalleryViewModel!

  override func setUp() {
    mockFetchGallery = MockFetchGallery()
    mockSearchGallery = MockSearchGallery()

    sut = GalleryViewModel(mockFetchGallery, mockSearchGallery)
  }

  override func tearDown() {
    mockFetchGallery = nil
    mockSearchGallery = nil
    sut = nil
    cancellables.removeAll()
  }

  func testInitialLoad_Success() {
    let expectedData = createGalleryResponse()

    loadData(expectedData) {
      mockFetchGallery.whenExecute = success(expectedData)
      sut.initialLoad()
    }
  }
  
  func testInitialLoad_Failed() {
    let error = ApiError.failToDecode
    
    loadDataFailed(error) {
      mockFetchGallery.whenExecute = failed(error)
      sut.initialLoad()
    }
  }
  
  func testSearch_success() {
    let expectedQuery = randomString(2)
    let expectedData = createGalleryResponse()
    
    loadData(expectedData, expectedQuery) {
      mockSearchGallery.whenExecute = success(expectedData)
      sut.search(expectedQuery)
    }
  }
  
  func testSearch_Failed() {
    let error = ApiError.failToDecode
    
    loadDataFailed(error) {
      mockSearchGallery.whenExecute = failed(error)
      sut.search(randomString(2))
    }
  }
  
  private func loadData(
    _ expectedData: GalleryResponse,
    _ expectedQuery: String = "",
    _ action: () -> Void
  ) {
    let expectedViewState = GalleryViewState(
      isLoading: false,
      gallery: expectedData.data,
      currentPage: expectedData.pagination.currentPage,
      imageUrl: expectedData.config.iiifUrl,
      isSearchMode: !expectedQuery.isEmpty, 
      query: expectedQuery
    )

    action()

    let expectation = self.expectation(description: "Initial Load Completed")
    var receivedValues: [GalleryViewState] = []

    sut.$viewState.sink { viewState in
      receivedValues.append(viewState)
  
      if receivedValues.count == 3 {
        expectation.fulfill()
      }
    }.store(in: &cancellables)
    
    waitForExpectations(timeout: 5.0, handler: nil)
    XCTAssertEqual(expectedViewState, receivedValues.last)
    XCTAssertTrue(receivedValues.last?.currentPage == expectedData.pagination.currentPage)
    XCTAssertTrue(receivedValues.last?.isLoading == false)
  }
  
  private func loadDataFailed(_ error: Error, _ action: () -> Void) {
    let expectedError = GalleryErrorState.errorEmptyData

    let expectation = self.expectation(description: "Load Failed")
    var receivedValues: [GalleryViewState] = []

    action()
    
    sut.$viewState.sink { viewState in
      receivedValues.append(viewState)

      if receivedValues.count == 2 {  //initial value and updated value
        expectation.fulfill()
      }
    }.store(in: &cancellables)

    waitForExpectations(timeout: 5.0, handler: nil)
    XCTAssertEqual(receivedValues.last?.error, expectedError)
    XCTAssertTrue(receivedValues.last?.isLoading == false)
    XCTAssertTrue(receivedValues.last?.currentPage == 0)
  }
  
  func testLoadSecondPage_Success() {
    let expectedData = createGalleryResponse()
    let expectedSecondData = createGalleryResponse(2)

    mockFetchGallery.whenExecute = success(expectedData)
    sut.initialLoad()

    let expectation = self.expectation(description: "Load second page Completed")
    var receivedValues: [GalleryViewState] = []

    sut.$viewState.sink { viewState in
      receivedValues.append(viewState)
      
      if receivedValues.count == 4 {
        if let id = viewState.gallery.last?.id {
          self.mockFetchGallery.whenExecute = success(expectedSecondData)
          self.sut.checkIfLoadNext(id)
        }
      } else if receivedValues.count == 7 {
        expectation.fulfill()
      }
    }.store(in: &cancellables)
    
    waitForExpectations(timeout: 5.0, handler: nil)
    XCTAssertEqual(receivedValues[3].gallery, expectedData.data)
    XCTAssertEqual(receivedValues[3].currentPage, expectedData.pagination.currentPage)
    XCTAssertTrue(receivedValues[3].isLoading == false)
    
    let finalGalleryItems = expectedData.data + expectedSecondData.data
    
    XCTAssertEqual(receivedValues.last?.gallery, finalGalleryItems)
    XCTAssertEqual(receivedValues.last?.currentPage, expectedSecondData.pagination.currentPage)
    XCTAssertTrue(receivedValues.last?.isLoading == false)
  }
  
  func testLoadSecondPage_Failed() {
    let expectedData = createGalleryResponse()
    let expectedErrorState = GalleryErrorState.errorOnScroll
    let error = ApiError.failToDecode

    mockFetchGallery.whenExecute = success(expectedData)
    sut.initialLoad()

    let expectation = self.expectation(description: "Load Second page failed")
    var receivedValues: [GalleryViewState] = []

    sut.$viewState.sink { viewState in
      receivedValues.append(viewState)
      
      if receivedValues.count == 4 {
        if let id = viewState.gallery.last?.id {
          self.mockFetchGallery.whenExecute = failed(error)
          self.sut.checkIfLoadNext(id)
        }
      } else if receivedValues.count == 7 {
        expectation.fulfill()
      }
    }.store(in: &cancellables)
    
    waitForExpectations(timeout: 5.0, handler: nil)
    XCTAssertEqual(receivedValues[3].gallery, expectedData.data)
    XCTAssertEqual(receivedValues[3].currentPage, expectedData.pagination.currentPage)
    XCTAssertTrue(receivedValues[3].isLoading == false)
  
    XCTAssertEqual(receivedValues.last?.gallery, expectedData.data)
    XCTAssertEqual(receivedValues.last?.currentPage, expectedData.pagination.currentPage)
    XCTAssertTrue(receivedValues.last?.isLoading == false)
    XCTAssertEqual(receivedValues.last?.error, expectedErrorState)
  }
  
  func testSearchLoadSecondPage_Success() {
    let expectedData = createGalleryResponse()
    let expectedSecondData = createGalleryResponse(2)
    let query = randomString(2)

    mockSearchGallery.whenExecute = success(expectedData)
    sut.search(query)

    let expectation = self.expectation(description: "Load second page of search Completed")
    var receivedValues: [GalleryViewState] = []

    sut.$viewState.sink { viewState in
      receivedValues.append(viewState)
      if receivedValues.count == 4 {
        if let id = viewState.gallery.last?.id {
          self.mockSearchGallery.whenExecute = success(expectedSecondData)
          self.sut.checkIfLoadNext(id)
        }
      } else if receivedValues.count == 8 {
        expectation.fulfill()
      }
    }.store(in: &cancellables)
    
    waitForExpectations(timeout: 5.0, handler: nil)
    XCTAssertEqual(receivedValues[3].gallery, expectedData.data)
    XCTAssertEqual(receivedValues[3].currentPage, expectedData.pagination.currentPage)
    XCTAssertTrue(receivedValues[3].isLoading == false)
    XCTAssertTrue(receivedValues[3].isSearchMode == true)
    
    let finalGalleryItems = expectedData.data + expectedSecondData.data
    
    XCTAssertEqual(receivedValues.last?.gallery, finalGalleryItems)
    XCTAssertEqual(receivedValues.last?.currentPage, expectedSecondData.pagination.currentPage)
    XCTAssertTrue(receivedValues.last?.isLoading == false)
    XCTAssertTrue(receivedValues.last?.isSearchMode == true)
  }
  
  func testSearchLoadSecondPage_Failed() {
    let expectedData = createGalleryResponse()
    let expectedErrorState = GalleryErrorState.errorOnScroll
    let error = ApiError.failToDecode
    let query = randomString(2)

    mockSearchGallery.whenExecute = success(expectedData)
    sut.search(query)

    let expectation = self.expectation(description: "Load second page of search failed")
    var receivedValues: [GalleryViewState] = []

    sut.$viewState.sink { viewState in
      receivedValues.append(viewState)
      if receivedValues.count == 4 {
        if let id = viewState.gallery.last?.id {
          self.mockSearchGallery.whenExecute = failed(error)
          self.sut.checkIfLoadNext(id)
        }
      } else if receivedValues.count == 7 {
        expectation.fulfill()
      }
    }.store(in: &cancellables)
    
    waitForExpectations(timeout: 5.0, handler: nil)
    XCTAssertEqual(receivedValues[3].gallery, expectedData.data)
    XCTAssertEqual(receivedValues[3].currentPage, expectedData.pagination.currentPage)
    XCTAssertTrue(receivedValues[3].isLoading == false)
    XCTAssertTrue(receivedValues[3].isSearchMode == true)
  
    XCTAssertEqual(receivedValues.last?.gallery, expectedData.data)
    XCTAssertEqual(receivedValues.last?.currentPage, expectedData.pagination.currentPage)
    XCTAssertTrue(receivedValues.last?.isLoading == false)
    XCTAssertTrue(receivedValues.last?.isSearchMode == true)
    XCTAssertEqual(receivedValues.last?.error, expectedErrorState)
  }
}

