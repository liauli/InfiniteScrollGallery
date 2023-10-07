//
//  PublisherResult.swift
//  InfiniteScrollGalleryTests
//
//  Created by Aulia Nastiti on 06/10/23.
//

import Combine
import Foundation

func success<T: Codable>(_ data: T) -> AnyPublisher<T, Error> {
  return Just(data).setFailureType(to: Error.self).eraseToAnyPublisher()
}

func failed<T: Codable>(_ error: Error) -> AnyPublisher<T, Error> {
  return Fail(error: error).eraseToAnyPublisher()
}
