//
//  ApiServiceTest.swift
//  InfiniteScrollGalleryTests
//
//  Created by Aulia Nastiti on 06/10/23.
//

import Combine
import Foundation
import XCTest

@testable import InfiniteScrollGallery

class APIServiceTest: XCTestCase {
  private var urlSession: URLSession!
  private var sut: APIService!
  private var jsonHelper: JsonHelper!

  private var cancellables: Set<AnyCancellable> = []

  override func setUp() {
    let configuration = URLSessionConfiguration.ephemeral
    configuration.protocolClasses = [MockURLProtocol.self]
    urlSession = URLSession(configuration: configuration)
    jsonHelper = JsonHelper()

    sut = APIServiceImpl(urlSession)
  }

  override func tearDown() {
    cancellables.removeAll()
    sut = nil
    urlSession = nil
  }

  func testFetchGalleryItems() throws {
    let mockGalleryData = try jsonHelper.readJson(
      "GalleryResponse",
      bundle: Bundle(for: type(of: self))
    ).data(using: .utf8)!
    let expectedData = jsonHelper.decodeJSON(
      GalleryResponse.self, from: mockGalleryData)
    
    MockURLProtocol.requestHandler = { request in
      return (HTTPURLResponse(), mockGalleryData)
    }

    let expectation = XCTestExpectation(description: "success")

    sut.fetchGalleryItems(1).sink { _ in
      expectation.fulfill()
    } receiveValue: { response in
      XCTAssertEqual(expectedData, response)
    }.store(in: &cancellables)

    wait(for: [expectation], timeout: 1)
  }

  func testFetchGalleryItemsFailed() throws {
    let mockData = Data()
    let expectedError = ApiError.failToDecode

    MockURLProtocol.requestHandler = { request in
      return (HTTPURLResponse(), mockData)
    }

    let expectation = XCTestExpectation(description: "failed")

    sut.fetchGalleryItems(1).sink { completion in
      if case .failure(let error) = completion, let error = error as? ApiError {
        XCTAssertEqual(expectedError, error)
        expectation.fulfill()
      }
    } receiveValue: { _ in
      //no result
    }.store(in: &cancellables)

    wait(for: [expectation], timeout: 1)
  }
}
